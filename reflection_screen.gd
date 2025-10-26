extends Node2D
signal all_improvement_cards_complete

var setVariables = false

var flaggedEventIndices: Array = []

var currFlaggedSubIndex = 0

@onready var cardscene = preload("res://improvement_card.tscn")


var total_sentiment_improvement = 0.0
var successful_improvements = 0
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
	
	var sentiment_score = GlobalData.basic_sentiment_analysis(improvement_text)
	print("Improvement: ", improvement_text)
	print("Card index: ", card_index)
	print("Sentiment score: ", sentiment_score)

	total_sentiment_improvement += sentiment_score - GlobalData.mood_data_points[card_index]
	
	if sentiment_score >= GlobalData.sentiment_goal:
		successful_improvements += 1
	
	currFlaggedSubIndex = currFlaggedSubIndex + 1
	if currFlaggedSubIndex < flaggedEventIndices.size():
		generate_improvement_card()
	else:
		emit_signal("all_improvement_cards_complete")
	pass
	


func _on_all_improvement_cards_complete() -> void:
	var average_sentiment_improvement = total_sentiment_improvement / flaggedEventIndices.size() if flaggedEventIndices.size() > 0 else 0.0
	var message = ""
	if flaggedEventIndices.size() == 0:
		message = "Congratulations, all your recorded events surpassed your mood goal for the day!!"
	elif successful_improvements == flaggedEventIndices.size():
		message = "Excellent! All your improvements have met the sentiment goal! The rain has completely dissipated."
	elif successful_improvements > flaggedEventIndices.size() / 2:
		message = "Good job! The majority of your improvements met your personal goal. The rain is lightening to a drizzle."
	else:
		message = "You at least put effort reflecting on your subpar events. Keep working on positive thinking!"
	
	
	$CongratsLabel.text = message
	$CongratsLabel.visible = true
	
	$ImprovementCardProgress.visible = false
	$NetImprovementLabel.text = "Average Net Improvement: " + str(int(100.0 * average_sentiment_improvement)) + "%"
	$NetImprovementLabel.visible = true
	#do some more stuff
	pass # Replace with function body.
