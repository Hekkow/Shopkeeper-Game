"""

Buttons at the bottom of store screen for opening the ingredient to recipe or recipe to item menu
This script decides when they're shown or hidden

"""

extends HBoxContainer

func _ready() -> void:
	SignalManager.connect("ingredient_to_recipe_menu_opened", hide_buttons)
	SignalManager.connect("recipe_to_item_menu_opened", hide_buttons)
	SignalManager.connect("pot_done", hide_buttons)
	SignalManager.connect("escape_recipe_to_item", show_buttons)
	SignalManager.connect("escape_ingredient_to_recipe", show_buttons)
	SignalManager.connect("store_opened", show_buttons)
	# SignalManager.connect("store_closed", show_buttons)

func hide_buttons() -> void:
	for button in get_children():
		button.hide()

func show_buttons() -> void:
	for button in get_children():
		button.show()
