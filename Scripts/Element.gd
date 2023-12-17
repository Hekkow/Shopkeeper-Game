extends Resource
class_name Element

@export var a: int
@export var b: int
@export var c: int

static var elementNames = ["A", "B", "C"]
static var numberElements = 3
static var fillPercent = 75

func _init(_elements=[0, 0, 0]):
	a = _elements[0]
	b = _elements[1]
	c = _elements[2]

func arr() -> Array:
	return [a, b, c]

static func ingredients_to_element(ingredients) -> Element:
	var element = Element.new()
	for ingredient in ingredients:
		for i in range(len(element.arr())):
			element.add(i, ingredient.elements[i])
	return element

func add(index, value) -> void:
	match index:
		0:
			a += value
		1:
			b += value
		2:
			c += value

static func element_to_percentages(element) -> Array:
	var percentages = []
	var maximum = get_max(element)
	for i in range(len(element.arr())):
		percentages.append(float(element.arr()[i])/maximum*fillPercent)
	return percentages

static func get_max(element):
	var _elements = element.arr()
	var maximum = 0
	for i in range(len(_elements)):
		if _elements[i] > maximum:
			maximum = _elements[i]
	return maximum

func _to_string():
	return "%s: %s, %s: %s, %s: %s" % [elementNames[0], str(a), elementNames[1], str(b), elementNames[2], str(c)]
