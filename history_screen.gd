extends Node2D


var pageNum = 0 #0-indexed
var pages = 1

var setVariables = false

var sortByNewest = false

@onready var record_item = preload("res://record_item.tscn")
var record_items = []

func _ready():
	var numEntries = GlobalData.prompt_responses_during_day.size() - 1
	pages = ceil((numEntries-1) / 4) + 1
	generate_records()
	pass

func _on_back_button_pressed() -> void:
	get_tree().change_scene_to_file("res://HomeScreen.tscn")
	pass # Replace with function body.


func _process(delta):
	var numEntries = GlobalData.prompt_responses_during_day.size()-1
	pages = ceil((numEntries-1) / 4) + 1
	$PrevPage.disabled = (pageNum <= 0)
	$NextPage.disabled = (pageNum >= pages-1)
	
	$PageLabel.text = "Page " + str(pageNum + 1) + " of " + str(pages)
	
	$NoWeatherHistoryLabel.visible = GlobalData.prompt_responses_during_day.size() < 2
	
	if int(GlobalData.currTime) == int(GlobalData.bedtime):
		get_tree().change_scene_to_file("res://nighttime_screen.tscn")
	
	var estimated_mood = GlobalData.get_current_mood(GlobalData.currTime)
	var estimated_mood_percent = round(estimated_mood * 100)
	
	var comment = ""
	if estimated_mood <= 0.2:
		comment = "very down"
		$WeatherBG.play("weather0")
	elif estimated_mood > 0.2 and estimated_mood <= 0.4:
		comment = "down"
		$WeatherBG.play("weather20")
	elif estimated_mood > 0.4 and estimated_mood < 0.6:
		comment = "neutral"
		$WeatherBG.play("weather40")
	elif estimated_mood >= 0.6 and estimated_mood < 0.8:
		comment = "cheerful"
		$WeatherBG.play("weather80")
	elif estimated_mood >= 0.8 and estimated_mood <= 1.0:
		comment = "very cheerful"
		$WeatherBG.play("weather100")

	pass
	
	
	
	
func generate_records():
	for record_item in record_items:
		record_item.queue_free()	
	record_items = []
	
	if not sortByNewest:
		for i in range (4):
			
			var currIndex = 4*pageNum + i + 1
			if currIndex < GlobalData.prompt_responses_during_day.size():
				var item = record_item.instantiate()
				item.global_position = Vector2(0, 60 + 120*i)
				add_child(item)
				item.index = currIndex
				item.set_visible(true)
				record_items.append(item)
	
	else:
		for i in range (4):
			var currIndex = GlobalData.prompt_responses_during_day.size() - 1 - (4*pageNum + i)
			if currIndex < GlobalData.prompt_responses_during_day.size() and currIndex > 0:
				var item = record_item.instantiate()
				item.global_position = Vector2(0, 60 + 120*i)
				add_child(item)
				item.index = currIndex
				item.set_visible(true)
				record_items.append(item)
			
	
	pass


func _on_next_page_pressed() -> void:
	pageNum = min(pages - 1, pageNum + 1)
	generate_records()
	pass # Replace with function body.


func _on_prev_page_pressed() -> void:
	pageNum = max(0, pageNum - 1)
	generate_records()
	pass # Replace with function body.


func _on_sort_toggle_button_toggled(toggled_on: bool) -> void:
	sortByNewest = toggled_on
	if toggled_on:
		$SortToggleButton.text = "Sorting by Newest"
	else:
		$SortToggleButton.text = "Sorting by Oldest"
	pageNum = 0
	generate_records()

	pass # Replace with function body.
