extends Node2D


func _ready():
	if GlobalData.username != "": 
		$NameField.text = GlobalData.username
	
func _on_button_pressed() -> void:
	GlobalData.username = $NameField.text
	print(GlobalData.username)
	pass # Replace with function body.
