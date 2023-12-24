extends Node2D

var item_scene
var character_scene
var item_class
func _ready() -> void:
	SignalManager.connect("store_opened", on_store_opened)
	SignalManager.connect("price_set", spawn_item)
	item_scene = load("res://Scenes/Objects/Item.tscn")
	character_scene = load("res://Scenes/Objects/Character.tscn")
	item_class = preload("res://Scripts/Objects/Item.gd")

func start() -> void:
	spawn_items()
	spawn_customers(2)

func on_store_opened() -> void:
	start()

func spawn_items() -> void:
	var radius = 500.0
	var max_angle = 90.0 * PI / 180
	for i in len(Data.all["Store Items Before"]):
		var item = item_scene.instantiate()
		item.set_script(item_class)
		item.set_variables(Data.all["Store Items Before"][i][0], Data.all["Store Items Before"][i][1], item.id)
		var x = radius * cos(max_angle/(len(Data.all["Store Items Before"])+1)*(i+1))
		var y = radius * sin(max_angle/(len(Data.all["Store Items Before"])+1)*(i+1))
		item.set_position(Vector2(x, y))
		add_child(item)

func spawn_item(_item: Item) -> void:
	print("HERE")
	var item = item_scene.instantiate()
	item.set_script(item_class)
	item.set_variables(_item.recipe, _item.price, _item.id)
	add_child(item)

func spawn_customers(number_customers: int) -> void:
	var customers := choose_customers(number_customers)
	for customer in customers:
		var character = character_scene.instantiate()
		character.name = customer.character_name
		character.get_node("Sprite2D").modulate = customer.color
		character._init(customer)
		add_child(character)
		await get_tree().create_timer(1).timeout

func choose_customers(number_customers) -> Array:
	# return [Helper.get_character("Green"), Helper.get_character("Blue"), Helper.get_character("Orange"), Helper.get_character("Salmon"), Helper.get_character("Red")]
	# return [Data.all["Characters"][2], Data.all["Characters"][3], Data.all["Characters"][4]]
	return Helper.random_sample(Data.all["Characters"], number_customers)

