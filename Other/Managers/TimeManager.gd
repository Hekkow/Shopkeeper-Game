extends Node

var time = 0
var day = 0
var time_per_day = 10
var seconds_per_time = 10

func _ready():
	var timer = Timer.new()
	timer.wait_time = seconds_per_time
	timer.timeout.connect(every_time_interval)
	add_child(timer)
	timer.start()
	SignalManager.connect("store_closed", on_store_closed)
	
func every_time_interval():
	time += 1
	if time == time_per_day:
		time = 0
		next_day()
	else:
		SignalManager.emit_signal("time_changed", time, day)
		
func on_store_closed():
	next_day()

func next_day():
	time = 0
	day += 1
	SignalManager.emit_signal("time_changed", time, day)