extends HBoxContainer

func _ready() -> void:
	SignalManager.connect("ingredient_to_recipe_menu_opened", hide_buttons)
	SignalManager.connect("recipe_to_item_menu_opened", hide_buttons)
	SignalManager.connect("pot_done", hide_buttons)
	SignalManager.connect("ingredient_to_recipe_panel_clicked", show_buttons)
	SignalManager.connect("recipe_to_item_clicked", show_buttons)

func hide_buttons() -> void:
	for button in get_children():
		button.hide()

func show_buttons() -> void:
	for button in get_children():
		button.show()
