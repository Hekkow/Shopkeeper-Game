extends Label

var pretext = "Time: "

func _ready():
	SignalManager.connect("time_changed", on_time_changed)
	text = pretext + str(TimeManager.time)

func on_time_changed(time, _day):
	text = pretext + str(time)