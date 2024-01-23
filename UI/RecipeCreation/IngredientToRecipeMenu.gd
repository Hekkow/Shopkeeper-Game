"""

Menu that initializes all ingredient buttons

"""

extends GridContainer

func _ready() -> void:
	initialize_ingredients()
	SignalManager.connect("ingredients_reset", on_ingredients_reset)
	

func on_ingredients_reset() -> void:
	Helper.remove_children(self)
	initialize_ingredients()
	
func initialize_ingredients() -> void:
	for ingredient_slot in Ingredients.inventory.inv:
		var button = Paths.item_display_button.instantiate()
		button.set_script(IngredientButton)
		button.slot = ingredient_slot
		add_child(button)


