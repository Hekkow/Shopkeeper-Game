extends Button
class_name PotButton
var recipe

func _ready():
	text = recipe.recipe_name
	
func _pressed():
	Recipes.inventory.add(recipe)
	Ingredients.pot.inv = []
	SignalManager.emit_signal("recipe_made")
	SignalManager.emit_signal("ingredients_reset")
	queue_free()