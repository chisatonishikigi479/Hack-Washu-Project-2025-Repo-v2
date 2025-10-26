extends Node2D

var setVariables = false

func _on_back_button_pressed() -> void:
	get_tree().change_scene_to_file("res://WakeUpScreen.tscn")
	pass # Replace with function body.

func _process(delta):
	if not setVariables:
		
		
		setVariables = true
		
	if int(GlobalData.currTime) == int(GlobalData.bedtime):
		get_tree().change_scene_to_file("res://nighttime_screen.tscn")
