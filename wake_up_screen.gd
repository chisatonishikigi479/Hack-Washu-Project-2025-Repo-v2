extends Node2D

var dataHasBeenSet = false

func _process(delta):
	if not dataHasBeenSet:
		if GlobalData.username != "":
			$NameLabel.text = GlobalData.username + "!"
		else:
			$RichTextLabel.text = "Good Morning!"
		$HowAreYouFeeling.text = "How Are You Feeling on this Beautiful " + GlobalData.get_current_weekday() + " Morning?"
		dataHasBeenSet = true 
	$CurrentTimeLabel.text = "Current Time: " + GlobalData.minutes_to_time_string(GlobalData.currTime)


func _on_button_pressed() -> void:
	get_tree().change_scene_to_file("res://HomeScreen.tscn")
	pass # Replace with function body.


func _on_initial_slider_value_changed(value: float) -> void:
	if GlobalData.mood_data_points.size() == 0:
		GlobalData.mood_data_points.append(value)
	else:
		GlobalData.mood_data_points[0] = value
	print(GlobalData.mood_data_points[0])
	var theValue = GlobalData.mood_data_points[0] 
	
	if theValue <= 0.2:
		$FeelingComment.text = "very down"
	elif theValue > 0.2 and theValue <= 0.4:
		$FeelingComment.text = "down"
	elif theValue > 0.4 and theValue < 0.6:
		$FeelingComment.text = "neutral"
	elif theValue >= 0.6 and theValue < 0.8:
		$FeelingComment.text = "cheerful"
	elif theValue >= 0.8 and theValue <= 1.0:
		$FeelingComment.text = "very cheerful"
		
	
	pass # Replace with function body.


func _on_settings_button_pressed() -> void:
	get_tree().change_scene_to_file("res://SettingsScreen.tscn")
	pass # Replace with function body.
