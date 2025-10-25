extends Node2D

func _process(delta):
	$Window/WindowLabel.text = "Please wait " + str(int (GlobalData.cooldownminutes - (GlobalData.currTime - GlobalData.cooldownstarted) ) ) + " minutes until submitting again!"


func _on_window_dismiss_button_pressed() -> void:
	$Window.hide()
	pass # Replace with function body.
