extends Label

var pretext = "Day "

func _ready():
	SignalManager.connect("time_changed", on_time_changed)
	text = pretext + str(TimeManager.time.day)

func on_time_changed(time):
	text = pretext + str(time.day)
