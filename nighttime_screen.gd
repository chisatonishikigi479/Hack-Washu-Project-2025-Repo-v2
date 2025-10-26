extends Node2D

var setVariables = false

func _process(delta):
	if int(GlobalData.currTime) == int(GlobalData.wakeUpTime):
		get_tree().change_scene_to_file("res://WakeUpScreen.tscn")
		
	if not setVariables:
		
		var estimated_mood = GlobalData.get_current_mood(GlobalData.bedtime)
		var comment = ""
		if estimated_mood <= 0.2:
			comment = "very low"
		elif estimated_mood > 0.2 and estimated_mood <= 0.4:
			comment = "low"
		elif estimated_mood > 0.4 and estimated_mood < 0.6:
			comment = "neutral"
		elif estimated_mood >= 0.6 and estimated_mood < 0.8:
			comment = "high"
		elif estimated_mood >= 0.8 and estimated_mood <= 1.0:
			comment = "very high"
		
		if GlobalData.username == "":
			$HowTheDayEnded.text = "Hi, you ended the day on a " + comment + " note (" + str(int(100.0 * estimated_mood)) + "%). Before going to bed, now it's time to reflect. "
		else:
			$HowTheDayEnded.text = "Hi " + GlobalData.username + ", you ended the day on a " + comment + " note (" + str(int(100.0 * estimated_mood)) + "%). Before going to bed, now it's time to reflect. "
			
			
		if estimated_mood > GlobalData.sentiment_goal:
			$SentimentGoalInfo.text = "(You beat your sentiment goal of " + str(int(100.0 * GlobalData.sentiment_goal)) + "% by " + str(int(100.0 * (estimated_mood - GlobalData.sentiment_goal)))+ "%)"
		elif estimated_mood == GlobalData.sentiment_goal:
			$SentimentGoalInfo.text = "(You reached your sentiment goal of " + str(int(100.0 * GlobalData.sentiment_goal)) + "% exactly!)"
		else:
			$SentimentGoalInfo.text = "(You didn't quite reach your sentiment goal of " + str(int(100.0 * GlobalData.sentiment_goal)) + ".)"
		setVariables = true
	$TimeLabel.text = "Current Time: " + GlobalData.minutes_to_time_string(GlobalData.currTime)
	


func _on_continue_button_pressed() -> void:
	get_tree().change_scene_to_file("res://ReflectionScreen.tscn")
	pass # Replace with function body.
