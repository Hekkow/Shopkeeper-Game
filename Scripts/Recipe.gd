extends Node
class_name Recipe
var recipeName
var elements
func _init(_recipeName, _elements):
	recipeName = _recipeName
	elements = _elements

func equals(recipe):
	for i in range(len(elements.elements)):
		if elements.elements[i] != recipe[i]:
			return false
	return true

func _to_string():
	return recipeName + " " + elements.to_string()
