extends Resource

class_name Personality

@export var a: int
@export var b: int
@export var c: int

func _init(_a, _b, _c):
	a = _a
	b = _b
	c = _c

func matches_personality(_element: Element) -> bool:
	return true