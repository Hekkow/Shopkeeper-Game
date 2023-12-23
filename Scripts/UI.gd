extends Node

var grid

func _ready():
	$Button.pressed.connect(load_recipe_screen)
	$Button2.pressed.connect(load_item_screen)
	pass
	# grid = $MarginContainer/ScrollContainer/GridContainer
	# $CenterContainer2/Button.pressed.connect(start_store)
	# load_items()

func load_recipe_screen():
	var scene := load("res://Scenes/Recipes.tscn")
	var recipes_screen = scene.instantiate()
	add_child(recipes_screen)

func load_item_screen():
	print("ITEM")


func start_store():
	get_tree().change_scene_to_file("res://store.tscn")
	# var store = scene.instantiate()


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
	Data.all["Store Items Before"].append([recipe, int(price)])
	price_input.queue_free()
	toggle_buttons(true)

func toggle_buttons(on):
	for button in grid.get_children():
		button.disabled = !on

