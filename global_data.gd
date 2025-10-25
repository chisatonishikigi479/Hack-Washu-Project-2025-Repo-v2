extends Node
#track time in minutes elapsed from 00:00
var bedtime = 1380
var wakeUpTime = 480 #default values
var username = ""
var sentiment_goal = 0.5 #between 0.0 and 1.0 inclusive

var mood_data_points: Array = [] #indexed starting from 0

var prompt_responses_during_day: Array = [] #array of strings



func setup():
	prompt_responses_during_day.append("") #0-index prompt is automatically empty bc the app doesn't ask how you're feeling on the title screen
	

	
