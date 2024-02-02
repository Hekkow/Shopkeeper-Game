class_name ScheduleSlot
extends Resource

@export var hour: int = 0
@export var day: int = 0
var time: TheTime
@export var pos: Vector2i

func _init():
	call_deferred("ready")
	
func ready():
	time = TheTime.new(hour, day)

func _to_string():
	return "Day %s Hour %s Go to %s" % [day, hour, pos]
