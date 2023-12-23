extends GridContainer

func _ready() -> void:
	load_items()
	SignalManager.connect("recipe_pressed", on_recipe_pressed)
	SignalManager.connect("price_set", on_price_set)

func load_items() -> void:
	var scene := load("res://Scenes/UI/ItemDisplayButton.tscn")
	for inventory_slot in Data.all["Recipe Inventory"]:
		var button = scene.instantiate()
		button.set_script(RecipeButton)
		button.slot = inventory_slot
		add_child(button)
		

func toggle_buttons(on: bool) -> void:
	for button in get_children():
		button.disabled = !on

func on_recipe_pressed() -> void:
	toggle_buttons(false)

func on_price_set() -> void:
	toggle_buttons(true)
	if len(Data.all["Recipe Inventory"]) == 0:
		SignalManager.emit_signal("store_opened")
