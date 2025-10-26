extends Node2D

#400 by 150 pixels
#display 4 per page

var index = 0

var setVariables = false
func _process(delta):
	if not setVariables:
		$TimestampLabel.text = "Timestamp: " + GlobalData.minutes_to_time_string(GlobalData.mood_time_stamps[index])
		var mood = GlobalData.mood_data_points[index]
		var comment = ""
		if mood <= 0.2:
			comment = "very down"
			$WeatherIcon.play("0percent")
		elif mood > 0.2 and mood <= 0.4:
			comment = "down"
			$WeatherIcon.play("20percent")
		elif mood > 0.4 and mood < 0.6:
			comment = "neutral"
			$WeatherIcon.play("40percent")
		elif mood >= 0.6 and mood < 0.8:
			comment = "cheerful"
			$WeatherIcon.play("80percent")
		elif mood >= 0.8 and mood <= 1.0:
			comment = "very cheerful"
			$WeatherIcon.play("100percent")
		$MoodLabel.text = "Mood: " + str(int(mood * 100.0)) + "%" + " (" + comment + ")"
		$ExplanationLabel.text = "Your Thoughts: " + "\"" + GlobalData.prompt_responses_during_day[index] + "\""
		
		setVariables = true
