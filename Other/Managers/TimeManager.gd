extends Node

var time_per_day = 10
var seconds_per_time = 1

var time = TheTime.new(0, 0)

func _ready():
	var timer = Timer.new()
	timer.wait_time = seconds_per_time
	timer.timeout.connect(every_time_interval)
	add_child(timer)
	timer.start()
	SignalManager.connect("store_closed", on_store_closed)
	
func every_time_interval():
	time.hour += 1
	if time.hour == time_per_day:
		time.hour = 0
		next_day()
	else:
		SignalManager.emit_signal("time_changed", time)
		
func on_store_closed():
	next_day()

func next_day():
	time.hour = 0
	time.day += 1
	SignalManager.emit_signal("time_changed", time)
	SignalManager.emit_signal("next_day", time)
