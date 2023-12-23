extends Resource
class_name Priority
var obj: Object
var prio: int

func _init(_obj: Object, _prio: int) -> void:
	obj = _obj
	prio = _prio

func _to_string() -> String:
	return "%s priority: %s" % [obj, prio]