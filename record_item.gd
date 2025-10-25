extends Node2D

#400 by 150 pixels
#display 4 per page

var index = 0

var setVariables = false
func _process(delta):
	if not setVariables:
		$Timestamp.text = "Timestamp: " + GlobalData.minutes_to_time_string(GlobalData.mood_time_stamps[index])
		var mood = GlobalData.mood_data_points[index]
		var comment = ""
		if mood <= 0.2:
			comment = "very down"
		elif mood > 0.2 and mood <= 0.4:
			comment = "down"
		elif mood > 0.4 and mood < 0.6:
			comment = "neutral"
		elif mood >= 0.6 and mood < 0.8:
			comment = "cheerful"
		elif mood >= 0.8 and mood <= 1.0:
			comment = "very cheerful"
		$MoodLabel.text = "Mood: " + str(int(mood * 100.0)) + "%" + " (" + comment + ")"
		$ExplanationLabel.text = GlobalData.prompt_responses_during_day[index]
		
		setVariables = true
