extends Node2D


func _on_wakeup_slider_value_changed(value: float) -> void:
	$WakeupLabel.text = GlobalData.minutes_to_time_string(int(value))
	GlobalData.wakeUpTime = value
	
	print(GlobalData.wakeUpTime)
	pass # Replace with function body.
