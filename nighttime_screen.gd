extends Node2D



func _process(delta):
	if int(GlobalData.currTime) == int(GlobalData.wakeUpTime):
		get_tree().change_scene_to_file("res://WakeUpScreen.tscn")
	$TimeLabel.text = "Current Time: " + GlobalData.minutes_to_time_string(GlobalData.currTime)
