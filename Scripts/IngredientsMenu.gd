extends GridContainer

func _ready():
	initialize_ingredients()
	SignalManager.connect("ingredients_reset", on_ingredients_reset)

func on_ingredients_reset():
	Helper.remove_children(self)
	for i in range(len(Data.all["Pot Ingredients"]) - 1, -1, -1):
		var ingredient_slot = Data.all["Pot Ingredients"][i]
		Data.add_to_inventory("Ingredient Inventory", ingredient_slot.object, ingredient_slot.amount)
		Data.remove_from_inventory("Pot Ingredients", ingredient_slot.object)
	initialize_ingredients()
	
func initialize_ingredients():
	var scene := load("res://Scenes/ItemDisplayButton.tscn")
	for ingredient_slot in Data.all["Ingredient Inventory"]:
		var button = scene.instantiate()
		add_child(button)
		button.text = str(ingredient_slot)
		button.pressed.connect(Callable(on_ingredient_pressed).bind(button, ingredient_slot))

func on_ingredient_pressed(button, inventory_slot):
	Data.add_to_inventory("Pot Ingredients", inventory_slot.object)
	SignalManager.emit_signal("ingredient_added", inventory_slot)
	if (inventory_slot.subtract() == 0):
		Data.remove_from_inventory("Ingredient Inventory", inventory_slot.object)
		button.queue_free()
	else:
		button.text = str(inventory_slot)
	
