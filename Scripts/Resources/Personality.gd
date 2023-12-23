extends Resource

class_name Personality

@export var a: int
@export var b: int
@export var c: int

func _init(_a: int = 0, _b: int = 0, _c: int = 0):
	a = _a
	b = _b
	c = _c

func matches_personality(_element: Element) -> bool:
	return true

func diff(element: Element) -> int:
	return abs(a - element.a) + abs(b - element.b) + abs(c - element.c)

func _to_string() -> String:
	return "%s %s %s" % [a, b, c]