extends Node2D
class_name Schedule

signal schedule_time_reached

var schedule = {
	TheTime.new(2): Vector2i(4, 0)
}

func _ready():
	SignalManager.connect("time_changed", check_schedule)

func check_schedule(time):
	#print(time)
	#print(schedule)
	for schedule_time in schedule:
		if schedule_time.equals(time):
			schedule_time_reached.emit(schedule[schedule_time])
			return
	
