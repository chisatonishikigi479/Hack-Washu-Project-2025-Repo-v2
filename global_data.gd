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
			
	print("current mood: " + str(interpolate_mood_lagrange_normalized(GlobalData.currTime)))
		
		
	
func get_current_weekday() -> String:
	var date_dict = Time.get_date_dict_from_system()
	var weekday = date_dict["weekday"]
	var weekdays = ["Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"]
	return weekdays[weekday]


func interpolate_mood_lagrange_normalized(current_time: float) -> float:
	var n = mood_time_stamps.size()
	
	if n < 2:
		if n == 1:
			return mood_data_points[0]
		else:
			return 0.5
	
	var normalized_times = []
	for time in mood_time_stamps:
		normalized_times.append(time / 1000000.0)
	
	var normalized_current_time = current_time / 1000000.0
	
	var result: float = 0.0
	for i in range(n):
		var term = mood_data_points[i]
		for j in range(n):
			if i != j:
				if normalized_times[i] != normalized_times[j]:
					term *= (normalized_current_time - normalized_times[j]) / (normalized_times[i] - normalized_times[j])
		result += term
	
	return clamp(result, 0.0, 1.0)
