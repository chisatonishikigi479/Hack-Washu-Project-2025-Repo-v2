extends Node2D
signal all_improvement_cards_complete

var setVariables = false

var flaggedEventIndices: Array = []

var currFlaggedSubIndex = 0

@onready var cardscene = preload("res://improvement_card.tscn")

var curr_card_instance = null
func _process(delta):
	if int(GlobalData.currTime) == int(GlobalData.wakeUpTime):
		get_tree().change_scene_to_file("res://WakeUpScreen.tscn")
	if not setVariables:
		for i in range (1, GlobalData.prompt_responses_during_day.size()):
			if GlobalData.mood_data_points[i] < GlobalData.sentiment_goal:
				flaggedEventIndices.append(i)
		
		if flaggedEventIndices.size() == 0:
			$CongratsLabel.visible = true
			$ImprovementCardProgress.visible = false
		else:
			generate_improvement_card()
		
		setVariables = true
	
	$TimeLabel.text = "Current Time: " + GlobalData.minutes_to_time_string(GlobalData.currTime)
	$ImprovementCardProgress.text = "(" + str(currFlaggedSubIndex) + "/" + str(flaggedEventIndices.size()) +" completed)"

func generate_improvement_card():
	curr_card_instance = cardscene.instantiate()
	curr_card_instance.index = flaggedEventIndices[currFlaggedSubIndex]
	curr_card_instance.global_position = Vector2(0, 275)
	curr_card_instance.improvement_submitted.connect(self._on_improvement_card_submitted)
	add_child(curr_card_instance)
	curr_card_instance.visible = true
	
	pass
	
func _on_improvement_card_submitted(improvement_text: String, card_index: int):
	#do sentiment analysis
	
	print(improvement_text)
	print(str(card_index))
	
	currFlaggedSubIndex = currFlaggedSubIndex + 1
	if currFlaggedSubIndex < flaggedEventIndices.size():
		generate_improvement_card()
	else:
		emit_signal("all_improvement_cards_complete")
	pass
	


func _on_all_improvement_cards_complete() -> void:
	$CongratsLabel.text = "Congrats, you made an effort to improve all of your subpar events!"
	$CongratsLabel.visible = true
	#do some more stuff
	pass # Replace with function body.
