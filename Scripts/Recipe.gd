extends Node
class_name Recipe
var recipeName
var elements
var maxDiff = 0.2
static var maximum = 10000

func _init(_recipeName, _elements):
	recipeName = _recipeName
	elements = _elements

func equals(recipe):
	for i in range(len(elements.elements)):
		if abs(elements.elements[i] - recipe[i]) > maxDiff:
			return false
	return true

func _to_string():
	return recipeName + " " + elements.to_string()


static func check_recipes(_elements):
	var minimum = maximum
	var values = []
	var e = _elements.elements
	for i in range(len(e)):
		var amount = e[i]
		if amount < minimum and amount != 0:
			minimum = amount
	for i in range(len(e)):
		values.append(float(e[i])/float(minimum))
	for recipe in InitItems.recipes:
		if recipe.equals(values):
			return recipe