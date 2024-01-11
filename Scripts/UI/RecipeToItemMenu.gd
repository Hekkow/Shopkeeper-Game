"""

Grid of recipes, spawns buttons for each recipe every time it's created

"""

extends GridContainer

func _ready() -> void:
	load_items()
	
func load_items() -> void:
	var scene := load("res://Scenes/UI/ItemDisplayButton.tscn")
	for inventory_slot in Recipes.inventory.inv:
		var button = scene.instantiate()
		button.set_script(RecipeButton)
		button.slot = inventory_slot
		add_child(button)