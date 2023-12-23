extends Resource
class_name Recipe
@export var recipe_name: String
@export var element: Element
@export var base_price: int
var maxDiff = 0.2
static var maximum = 10000

func recipe_equals(recipe: Array) -> bool:
	for i in len(element.arr()):
		if abs(element.arr()[i] - recipe[i]) > maxDiff:
			return false
	return true

func equals(recipe: Recipe) -> bool:
	return recipe_name == recipe.recipe_name

func _to_string() -> String:
	return recipe_name

static func check_recipes(_elements: Element) -> Recipe:
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
	return null

static func find_recipe(name) -> Recipe:
	for recipe in Data.all["Recipes"]:
		if recipe.recipe_name == name:
			return recipe
	return null
