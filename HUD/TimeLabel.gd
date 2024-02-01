extends Label

var pretext = "Time: "

func _ready():
	SignalManager.connect("time_changed", on_time_changed)
	text = pretext + str(TimeManager.time.hour)

func on_time_changed(time):
	text = pretext + str(time.hour)
