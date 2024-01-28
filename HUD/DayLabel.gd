extends Label

var pretext = "Day "

func _ready():
	SignalManager.connect("time_changed", on_time_changed)
	text = pretext + str(TimeManager.day)

func on_time_changed(_time, day):
	text = pretext + str(day)