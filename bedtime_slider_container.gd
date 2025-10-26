extends Node2D

func _ready():
	$BedtimeSlider.value = GlobalData.bedtime

func _on_bedtime_slider_value_changed(value: float) -> void:
	$BedtimeLabel.text = GlobalData.minutes_to_time_string(int(value))
	if value < 1440:
		GlobalData.bedtime = value
	else:
		GlobalData.bedtime = value - 1440
	
	print(GlobalData.bedtime)
	pass # Replace with function body.
