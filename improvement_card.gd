extends Node2D

signal improvement_submitted(improvement_text, card_index)
#put on bottom of reflection screen


var setVariables = false
var index = 0

func _process(delta):
	if not setVariables:
		
		var estimated_mood = GlobalData.mood_data_points[index]
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
		
		$EventDescription.text = "At " + GlobalData.minutes_to_time_string(GlobalData.mood_time_stamps[index]) + ", you felt " + comment + " due to \"" + GlobalData.prompt_responses_during_day[index] + "\". What might you do to self improve on this situation?"
		setVariables = true

func _on_submit_button_pressed() -> void:
	if $ReflectionResponseBox.text != "":
		var improvement_text = $ReflectionResponseBox.text 
		emit_signal("improvement_submitted", improvement_text, index)
		queue_free()
	
	pass # Replace with function body.
