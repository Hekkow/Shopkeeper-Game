extends Resource
class_name Recipe
@export var recipe_name: String
@export var element: Element
@export var base_price: int
var maxDiff = 0.2
static var maximum = 10000

# func _init(_recipeName="", _elements=Element.new()):
# 	recipe_name = _recipeName
# 	element = _elements

func recipe_equals(recipe):
	for i in len(element.arr()):
		if abs(element.arr()[i] - recipe[i]) > maxDiff:
			return false
	return true

func equals(recipe):
	return recipe_name == recipe.recipe_name

func _to_string():
	return recipe_name + " " + element.to_string()

static func check_recipes(_elements):
	var minimum = maximum
	var values = []
	var e = _elements.arr()
	for i in len(e):
		var amount = e[i]
		if amount < minimum and amount != 0:
			minimum = amount
	for i in len(e):
		values.append(float(e[i])/float(minimum))
	for recipe in Data.all["Recipes"]:
		if recipe.recipe_equals(values):
			return recipe

static func find_recipe(name):
	for recipe in Data.all["Recipes"]:
		if recipe.recipe_name == name:
			return recipe
	return null
