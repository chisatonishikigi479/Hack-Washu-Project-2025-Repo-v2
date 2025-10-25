extends Node
#track time in minutes elapsed from 00:00
var bedtime = 1320
var wakeUpTime = 360 #default values
var username = ""
var sentiment_goal = 0.5 #between 0.0 and 1.0 inclusive

var mood_data_points: Array = [] #indexed starting from 0
var mood_time_stamps: Array = [] #indexed starting frmo 0

var prompt_responses_during_day: Array = [] #array of strings

var currTime = wakeUpTime
var cooldown = false
var cooldownstarted = 0.0
var cooldownstartedbool = false
var cooldownminutes = 30.0

@export var customSpeedMultiplier = 60.0 #change to 1.0 later

func _ready():
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

func _process(delta: float):
	currTime = currTime + (customSpeedMultiplier) * delta * (1.0 / 60.0)
	if currTime >= 1440.0:
		currTime = 0.0
	if cooldown:
		if not cooldownstartedbool:
			cooldownstarted = currTime
			cooldownstartedbool = true
		if currTime - cooldownstarted >= cooldownminutes:
			cooldown = false
			cooldownstartedbool = false
		
		
	
func get_current_weekday() -> String:
	var date_dict = Time.get_date_dict_from_system()
	var weekday = date_dict["weekday"]
	var weekdays = ["Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"]
	return weekdays[weekday]
