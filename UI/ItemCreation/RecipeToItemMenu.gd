"""

Grid of recipes, spawns buttons for each recipe every time it's created

"""

extends GridContainer

func _ready() -> void:
	load_items()
	
func load_items() -> void:
	for inventory_slot in Recipes.inventory.inv:
		var button = Paths.item_display_button.instantiate()
		button.set_script(RecipeButton)
		button.slot = inventory_slot
		add_child(button)
