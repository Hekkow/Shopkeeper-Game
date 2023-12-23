extends GridContainer

func _ready() -> void:
	initialize_ingredients()
	SignalManager.connect("ingredients_reset", on_ingredients_reset)
	SignalManager.connect("recipe_made", on_recipe_made)

func on_ingredients_reset() -> void:
	Helper.remove_children(self)
	for i in range(len(Data.all["Pot Ingredients"]) - 1, -1, -1):
		var ingredient_slot = Data.all["Pot Ingredients"][i]
		Data.add_to_inventory("Ingredient Inventory", ingredient_slot.object, ingredient_slot.amount)
		Data.remove_from_inventory("Pot Ingredients", ingredient_slot.object)
	initialize_ingredients()
	
func initialize_ingredients() -> void:
	var scene := load("res://Scenes/UI/ItemDisplayButton.tscn")
	for ingredient_slot in Data.all["Ingredient Inventory"]:
		var button = scene.instantiate()
		button.set_script(IngredientButton)
		button.slot = ingredient_slot
		add_child(button)

func on_recipe_made() -> void:
	if len(Data.all["Ingredient Inventory"]) == 0:
		SignalManager.emit_signal("pot_done")