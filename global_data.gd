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

@export var customSpeedMultiplier = 1800.0 #change to 1.0 later

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
			
	#print("current mood: " + str(get_current_mood(GlobalData.currTime)))
		
		
	
func get_current_weekday() -> String:
	var date_dict = Time.get_date_dict_from_system()
	var weekday = date_dict["weekday"]
	var weekdays = ["Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"]
	return weekdays[weekday]



func get_current_mood(current_time: float) -> float:
	var n = mood_time_stamps.size()
	
	# Handle no data case
	if n == 0:
		return 0.5  # Default neutral mood
	
	# Handle single data point case
	if n == 1:
		return mood_data_points[0]
	
	# Sort data by time
	var sorted_times = []
	var sorted_moods = []
	
	var indices = range(n)
	indices.sort_custom(func(a, b): return mood_time_stamps[a] < mood_time_stamps[b])
	
	for i in indices:
		sorted_times.append(mood_time_stamps[i])
		sorted_moods.append(mood_data_points[i])
	
	# Normalize all times to [0, 1] range
	var normalized_times = []
	for time in sorted_times:
		normalized_times.append(time / 1440.0)
	
	var normalized_current_time = current_time / 1440.0
	
	# Check if we need to extrapolate
	if normalized_current_time < normalized_times[0]:
		# Extrapolate backward using first two points
		return extrapolate_backward(normalized_current_time, normalized_times, sorted_moods)
	elif normalized_current_time > normalized_times[n - 1]:
		# Extrapolate forward using last two points
		return extrapolate_forward(normalized_current_time, normalized_times, sorted_moods)
	else:
		# Interpolate between points
		return interpolate_cubic(normalized_current_time, normalized_times, sorted_moods)

# Extrapolate backward (before first data point)
func extrapolate_backward(current_time: float, times: Array, moods: Array) -> float:
	# Use linear extrapolation based on first two points
	if times.size() < 2:
		return moods[0]
	
	var t0 = times[0]
	var t1 = times[1]
	var m0 = moods[0]
	var m1 = moods[1]
	
	# Calculate slope
	if t1 == t0:
		return m0
	
	var slope = (m1 - m0) / (t1 - t0)
	
	# Extrapolate: mood = m0 + slope * (current_time - t0)
	var result = m0 + slope * (current_time - t0)
	return clamp(result, 0.0, 1.0)

# Extrapolate forward (after last data point)
func extrapolate_forward(current_time: float, times: Array, moods: Array) -> float:
	# Use linear extrapolation based on last two points
	var n = times.size()
	if n < 2:
		return moods[n - 1]
	
	var t0 = times[n - 2]
	var t1 = times[n - 1]
	var m0 = moods[n - 2]
	var m1 = moods[n - 1]
	
	# Calculate slope
	if t1 == t0:
		return m1
	
	var slope = (m1 - m0) / (t1 - t0)
	
	# Extrapolate: mood = m1 + slope * (current_time - t1)
	var result = m1 + slope * (current_time - t1)
	return clamp(result, 0.0, 1.0)

# Cubic interpolation between points
func interpolate_cubic(current_time: float, times: Array, moods: Array) -> float:
	var n = times.size()
	
	# Find the segment containing current_time
	var segment = -1
	for i in range(n - 1):
		if current_time >= times[i] and current_time <= times[i + 1]:
			segment = i
			break
	
	if segment == -1:
		return moods[n - 1]  # Fallback
	
	# Use Catmull-Rom spline for smooth interpolation
	return catmull_rom_interpolate(current_time, times, moods, segment)

# Catmull-Rom spline interpolation
func catmull_rom_interpolate(t: float, times: Array, moods: Array, segment: int) -> float:
	var n = times.size()
	
	# Get indices for the four points
	var i0 = max(segment - 1, 0)
	var i1 = segment
	var i2 = segment + 1
	var i3 = min(segment + 2, n - 1)
	
	var p0 = moods[i0]
	var p1 = moods[i1]
	var p2 = moods[i2]
	var p3 = moods[i3]
	
	var t0 = times[i0]
	var t1 = times[i1]
	var t2 = times[i2]
	var t3 = times[i3]
	
	# Normalize time to the segment [t1, t2]
	var t_local = (t - t1) / (t2 - t1) if t2 != t1 else 0.0
	
	# Catmull-Rom spline formula
	var result = 0.5 * (
		(2 * p1) +
		(-p0 + p2) * t_local +
		(2 * p0 - 5 * p1 + 4 * p2 - p3) * (t_local * t_local) +
		(-p0 + 3 * p1 - 3 * p2 + p3) * (t_local * t_local * t_local)
	)
	
	return clamp(result, 0.0, 1.0)
