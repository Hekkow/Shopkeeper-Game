extends Node

var grid

func _ready():
	grid = $MarginContainer/ScrollContainer/GridContainer
	load_items()
	print(grid)

func load_items():
	var scene := load("res://Scenes/ItemDisplayButton.tscn")
	for inventory_slot in Data.all["Recipe Inventory"]:
		var button = scene.instantiate()
		grid.add_child(button)
		button.text = str(inventory_slot)
		button.pressed.connect(Callable(on_recipe_pressed).bind(button, inventory_slot))

func on_recipe_pressed(button, inventory_slot):
	if inventory_slot.subtract() == 0:
		button.queue_free()
	else:
		button.text = str(inventory_slot)
	var scene := load("res://Scenes/PriceInput.tscn")
	var price_input = scene.instantiate()
	$CenterContainer.add_child(price_input)
	price_input.grab_focus()
	price_input.text_submitted.connect(on_price_enter.bind(inventory_slot.object, price_input))
	toggle_buttons(false)

func on_price_enter(price, recipe, price_input):
	Data.all["Store Items"].append(Item.new(recipe, int(price)))
	price_input.queue_free()
	toggle_buttons(true)

func toggle_buttons(on):
	for button in grid.get_children():
		button.disabled = !on