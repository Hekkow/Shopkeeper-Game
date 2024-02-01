extends Resource

class_name Schedule

signal schedule_time_reached

@export var schedule: Array[ScheduleSlot]

func _init():
	SignalManager.connect("time_changed", check_schedule)
	
func check_schedule(time):
	for schedule_slot in schedule:
		if schedule_slot.time.equals(time):
			schedule_time_reached.emit(schedule_slot)
			return
	
