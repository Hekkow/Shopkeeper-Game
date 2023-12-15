extends Node
class_name Element
var elements
static var elementNames = ["A", "B", "C"]
static var numberElements = 3
func _init(_elements=[0, 0, 0]):
	elements = _elements

static func ingredients_to_element(ingredients) -> Element:
	var element = Element.new()
	for ingredient in ingredients:
		for i in range(len(element.elements)):
			element.elements[i] += ingredient.elements[i]
	return element

static func element_to_percentages(element) -> Array:
	var percentages = []
	var maximum = get_max(element)
	for i in range(len(element.elements)):
		percentages.append(float(element.elements[i])/maximum*100)
	return percentages

static func get_max(element):
	var _elements = element.elements
	var maximum = 0
	for i in range(len(_elements)):
		if _elements[i] > maximum:
			maximum = _elements[i]
	return maximum

func _to_string():
	return "A: " + str(elements[0]) + ", B: " + str(elements[1]) + ", C: " + str(elements[2]) 
