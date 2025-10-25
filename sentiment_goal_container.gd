extends Node2D

func _ready():
	$SentimentSlider.value = GlobalData.sentiment_goal
	var value = GlobalData.sentiment_goal
	if value <= 0.2:
		$SentimentDescription.text = "very down"
	elif value > 0.2 and value <= 0.4:
		$SentimentDescription.text = "down"
	elif value > 0.4 and value < 0.6:
		$SentimentDescription.text = "neutral"
	elif value >= 0.6 and value < 0.8:
		$SentimentDescription.text = "cheerful"
	elif value >= 0.8 and value <= 1.0:
		$SentimentDescription.text = "very cheerful"
		


func _on_sentiment_slider_value_changed(value: float) -> void:
	GlobalData.sentiment_goal = value
	print(GlobalData.sentiment_goal)
	if value <= 0.2:
		$SentimentDescription.text = "very down"
	elif value > 0.2 and value <= 0.4:
		$SentimentDescription.text = "down"
	elif value > 0.4 and value < 0.6:
		$SentimentDescription.text = "neutral"
	elif value >= 0.6 and value < 0.8:
		$SentimentDescription.text = "cheerful"
	elif value >= 0.8 and value <= 1.0:
		$SentimentDescription.text = "very cheerful"
		
	pass # Replace with function body.
