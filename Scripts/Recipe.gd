extends Resource
class_name Recipe
@export var recipeName: String
@export var elements: Element
var maxDiff = 0.2
static var maximum = 10000

func _init(_recipeName="", _elements=Element.new()):
	recipeName = _recipeName
	elements = _elements

func recipe_equals(recipe):
	for i in range(len(elements.arr())):
		if abs(elements.arr()[i] - recipe[i]) > maxDiff:
			return false
	return true

func equals(recipe):
	return recipeName == recipe.recipeName && elements.equals(recipe.elements)

func _to_string():
	return recipeName + " " + elements.to_string()

static func check_recipes(_elements):
	var minimum = maximum
	var values = []
	var e = _elements.arr()
	for i in range(len(e)):
		var amount = e[i]
		if amount < minimum and amount != 0:
			minimum = amount
	for i in range(len(e)):
		values.append(float(e[i])/float(minimum))
	for recipe in Data.all["Recipes"]:
		if recipe.recipe_equals(values):
			return recipe