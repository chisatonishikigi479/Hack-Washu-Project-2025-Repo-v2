extends Node
#track time in minutes elapsed from 00:00
var bedtime = 1320
var wakeUpTime = 360 #default values
var username = ""
var sentiment_goal = 0.5 #between 0.0 and 1.0 inclusive

var mood_data_points: Array = [] #indexed starting from 0

var prompt_responses_during_day: Array = [] #array of strings



func setup():
	prompt_responses_during_day.append("") #0-index prompt is automatically empty bc the app doesn't ask how you're feeling on the title screen
	
func minutes_to_time_string(minutes: float) -> String:
	var clamped_minutes = int(minutes) % 1440
	var hours = clamped_minutes / 60
	var mins = clamped_minutes % 60
	var period = "AM"
	var display_hours = hours
	if hours >= 12:
		period = "PM"
		if hours > 12:
			display_hours = hours - 12
	if hours == 0:
		display_hours = 12  
	return "%d:%02d %s" % [display_hours, mins, period]

	
