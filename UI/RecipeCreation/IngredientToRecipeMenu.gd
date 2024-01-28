extends BaseGridMenu

func _ready():
	load_items(IngredientButton, Ingredients.inventory.inv, Paths.item_display_button)
	SignalManager.connect("ingredients_reset", on_ingredients_reset)
	

func on_ingredients_reset() -> void:
	remove_items()
	load_items(IngredientButton, Ingredients.inventory.inv, Paths.item_display_button)


