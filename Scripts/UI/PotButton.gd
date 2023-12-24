extends Button
class_name PotButton
var recipe

func _ready():
	text = recipe.recipe_name
	
func _pressed():
	Data.add_to_inventory("Recipe Inventory", recipe)
	Data.all["Pot Ingredients"] = []
	SignalManager.emit_signal("recipe_made")
	SignalManager.emit_signal("ingredients_reset")
	queue_free()