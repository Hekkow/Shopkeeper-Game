class_name TheTime
extends Node

@export var day: int
@export var hour: int

func _init(_hour: int, _day: int = -1):
	hour = _hour
	day = _day

func equals(time: TheTime):
	if day == -1:
		return hour == time.hour
	return day == time.day && hour == time.hour
	
func _to_string():
	return "Day: %s Hour: %s" % [day, hour]
