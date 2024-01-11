"""

Button that opens the ingredient to recipe menu

"""

extends Button

func _pressed() -> void:
	SignalManager.emit_signal("ingredient_to_recipe_menu_opened")
	
	
