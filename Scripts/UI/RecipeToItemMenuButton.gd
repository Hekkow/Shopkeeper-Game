"""

Button that opens recipe to item menu

"""

extends Button

func _pressed() -> void:
	SignalManager.emit_signal("recipe_to_item_menu_opened")
	
