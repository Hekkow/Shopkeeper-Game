extends GridContainer

func _ready() -> void:
	load_items()
	SignalManager.connect("recipe_pressed", on_recipe_pressed)
	SignalManager.connect("price_set", on_price_set)
	SignalManager.connect("item_placed", on_item_placed)

func load_items() -> void:
	var scene := load("res://Scenes/UI/ItemDisplayButton.tscn")
	for inventory_slot in Recipes.inventory.inv:
		var button = scene.instantiate()
		button.set_script(RecipeButton)
		button.slot = inventory_slot
		add_child(button)
		

func toggle_buttons(on: bool) -> void:
	for button in get_children():
		button.disabled = !on

func on_recipe_pressed(_recipe) -> void:
	toggle_buttons(false)

func on_price_set(_item) -> void:
	toggle_buttons(true)

func on_item_placed(_item) -> void:
	if len(Recipes.inventory.inv) == 0:
		SignalManager.emit_signal("store_opened")
