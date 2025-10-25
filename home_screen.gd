extends Node2D
var dataHasBeenSet = false
func _process(delta):
	if not dataHasBeenSet:
		#do stuff here if necessary
		$TellMeAboutYourDayContainer/FeelingSlider.value = GlobalData.mood_data_points[GlobalData.mood_data_points.size() - 1]
		if GlobalData.username != "":
			$TellMeAboutYourDayContainer/Encouragement.text = "Tell me something about your day, " + GlobalData.username + "..."
		else:
			$TellMeAboutYourDayContainer/Encouragement.text = "Tell me something about your day..."
		dataHasBeenSet = true 
	$CurrentTimeLabel.text = "Current Time: " + GlobalData.minutes_to_time_string(GlobalData.currTime)
	var estimated_mood = GlobalData.get_current_mood(GlobalData.currTime)
	var estimated_mood_percent = round(estimated_mood * 100)
	
	var comment = ""
	if estimated_mood <= 0.2:
		comment = "very down"
	elif estimated_mood > 0.2 and estimated_mood <= 0.4:
		comment = "down"
	elif estimated_mood > 0.4 and estimated_mood < 0.6:
		comment = "neutral"
	elif estimated_mood >= 0.6 and estimated_mood < 0.8:
		comment = "cheerful"
	elif estimated_mood >= 0.8 and estimated_mood <= 1.0:
		comment = "very cheerful"
	$EstimatedMoodLabel.text = "Estimated Current Mood: " + str(int(estimated_mood_percent)) + "%" + " (" + comment + ")"


func _on_history_button_pressed() -> void:
	get_tree().change_scene_to_file("HistoryScreen.tscn")
	pass # Replace with function body.


func _on_submit_button_pressed() -> void:
	if not GlobalData.cooldown:
		var textbox = $TellMeAboutYourDayContainer/JournalBox
		var feelingslider = $TellMeAboutYourDayContainer/FeelingSlider
		GlobalData.mood_data_points.append(feelingslider.value)
		GlobalData.prompt_responses_during_day.append(textbox.text)
		GlobalData.mood_time_stamps.append(GlobalData.currTime)
		print(GlobalData.prompt_responses_during_day)
		print(GlobalData.mood_data_points)
		print(GlobalData.mood_time_stamps)

		GlobalData.cooldown = true
		textbox.text = ""
	else: 
		#add stuff
		$CooldownNotice/Window.visible = true
		pass
	pass # Replace with function body.


func _on_feeling_slider_value_changed(value: float) -> void:
	
	if value <= 0.2:
		$TellMeAboutYourDayContainer/FeelingComment.text = "very down"
	elif value > 0.2 and value <= 0.4:
		$TellMeAboutYourDayContainer/FeelingComment.text = "down"
	elif value > 0.4 and value < 0.6:
		$TellMeAboutYourDayContainer/FeelingComment.text = "neutral"
	elif value >= 0.6 and value < 0.8:
		$TellMeAboutYourDayContainer/FeelingComment.text = "cheerful"
	elif value >= 0.8 and value <= 1.0:
		$TellMeAboutYourDayContainer/FeelingComment.text = "very cheerful"
		
	pass # Replace with function body.
