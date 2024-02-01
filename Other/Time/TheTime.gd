class_name TheTime
extends Resource

@export var day: int
@export var hour: int

func _init(_hour: int = 0, _day: int = 0):
	hour = _hour
	day = _day

func equals(time: TheTime):
	if day == 0:
		return hour == time.hour
	return day == time.day && hour == time.hour
	
func _to_string():
	return "Day: %s Hour: %s" % [day, hour]
