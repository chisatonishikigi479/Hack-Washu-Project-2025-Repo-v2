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
