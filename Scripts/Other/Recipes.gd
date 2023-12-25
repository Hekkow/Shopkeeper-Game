extends Node

var list: Array
var inventory = Inventory.new()
var maximum = 10000

func _ready():
	list = Helper.get_resources("Recipes")

func check_recipes(_elements: Element) -> Recipe:
	var minimum = maximum
	var values = []
	var e = _elements.arr()
	for i in len(e):
		var amount = e[i]
		if amount < minimum and amount != 0:
			minimum = amount
	for i in len(e):
		values.append(float(e[i])/float(minimum))
	for recipe in Recipes.list:
		if recipe.recipe_equals(values):
			return recipe
	return null

func find_recipe(recipe_name) -> Recipe:
	for recipe in list:
		if recipe.recipe_name == name:
			return recipe
	return null