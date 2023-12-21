extends Node
class_name Priority
var obj: Object
var prio: int

func _init(_obj, _prio):
	obj = _obj
	prio = _prio

func _to_string():
	return "%s priority: %s" % [obj, prio]