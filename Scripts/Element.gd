extends Resource
class_name Element

@export var a: int
@export var b: int
@export var c: int

static var elementNames = ["A", "B", "C"]
static var numberElements = 3
static var fillPercent = 75

func _init(_a=0, _b=0, _c=0):
	a = _a
	b = _b
	c = _c

func arr() -> Array:
	return [a, b, c]

func equals(element: Element) -> bool:
	return a == element.a && b == element.b && c == element.c

static func ingredients_to_element(inventory_slots) -> Element:
	var element = Element.new()
	for slot in inventory_slots:
		for i in numberElements:
			element.add(i, slot.object.element.arr()[i] * slot.amount)
	return element

func add(index, value) -> void:
	match index:
		0:
			a += value
		1:
			b += value
		2:
			c += value

func element_to_percentages() -> Array:
	var percentages = []
	var maximum = get_max()
	var elements = arr()
	for i in numberElements:
		percentages.append(float(elements[i])/maximum*fillPercent)
	return percentages

func get_max():
	var elements = arr()
	var maximum = 0
	for i in numberElements:
		if elements[i] > maximum:
			maximum = elements[i]
	return maximum

func _to_string():
	return "%s: %s, %s: %s, %s: %s" % [elementNames[0], str(a), elementNames[1], str(b), elementNames[2], str(c)]
