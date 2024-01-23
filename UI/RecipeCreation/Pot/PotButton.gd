"""

Button to create recipe

"""

extends Button
class_name PotButton
var recipe

func _ready():
	text = recipe.recipe_name
	
func _pressed():
	SignalManager.emit_signal("recipe_made", recipe)
	SignalManager.emit_signal("ingredients_reset")
	queue_free()