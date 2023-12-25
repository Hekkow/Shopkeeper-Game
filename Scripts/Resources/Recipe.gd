extends Resource
class_name Recipe
@export var recipe_name: String
@export var element: Element
@export var base_price: int
var maxDiff = 0.2

func recipe_equals(recipe: Array) -> bool:
	for i in len(element.arr()):
		if abs(element.arr()[i] - recipe[i]) > maxDiff:
			return false
	return true

func equals(recipe: Recipe) -> bool:
	return recipe_name == recipe.recipe_name

func _to_string() -> String:
	return recipe_name

