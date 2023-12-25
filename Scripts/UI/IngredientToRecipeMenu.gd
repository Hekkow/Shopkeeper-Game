extends GridContainer

func _ready() -> void:
	initialize_ingredients()
	SignalManager.connect("ingredients_reset", on_ingredients_reset)
	SignalManager.connect("recipe_made", on_recipe_made)

func on_ingredients_reset() -> void:
	Helper.remove_children(self)
	for i in range(len(Ingredients.pot.inv) - 1, -1, -1):
		var ingredient_slot = Ingredients.pot.inv[i]
		Ingredients.inventory.add(ingredient_slot.object, ingredient_slot.amount)
		Ingredients.pot.remove(ingredient_slot.object)
	initialize_ingredients()
	
func initialize_ingredients() -> void:
	var scene := load("res://Scenes/UI/ItemDisplayButton.tscn")
	for ingredient_slot in Ingredients.inventory.inv:
		var button = scene.instantiate()
		button.set_script(IngredientButton)
		button.slot = ingredient_slot
		add_child(button)

func on_recipe_made() -> void:
	if len(Ingredients.inventory.inv) == 0:
		SignalManager.emit_signal("pot_done")
