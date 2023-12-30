extends Node2D

class_name Store

var item_scene
var character_scene
var item_class
var display_cases = []
var door
var table
var customers = []
var store_open = false
var tilemap
var astar

func _ready() -> void:
	Data.store = self
	SignalManager.connect("store_opened", on_store_opened)
	SignalManager.connect("price_set", spawn_item)
	item_scene = load("res://Scenes/Objects/Item.tscn")
	character_scene = load("res://Scenes/Objects/Character.tscn")
	item_class = load("res://Scripts/Objects/Item.gd")
	print("here1")
	SignalManager.emit_signal("store_initialized")
	
	SignalManager.connect("customer_left", on_customer_left)
	SignalManager.connect("store_closing", on_store_closing)
	SignalManager.connect("astar_ready", on_astar_ready)

func on_astar_ready(astar_grid, _tilemap):
	print("here3")
	astar = astar_grid
	tilemap = _tilemap

func on_store_opened() -> void:
	store_open = true
	if len(Items.store) == 0:
		SignalManager.emit_signal("store_closed")
		return
	spawn_customers(1)

func spawn_item(_item: Item) -> void:
	var item = item_scene.instantiate()
	item.set_script(item_class)
	item.set_variables(_item)
	add_child(item)

func on_store_closing():
	store_open = false

func spawn_customers(_number_customers: int) -> void:
	var _customers := choose_customers(_number_customers)
	for customer in _customers:
		if !store_open:
			return
		var character = character_scene.instantiate()
		character.name = customer.character_name
		character.get_node("Sprite2D").modulate = customer.color
		character._init(customer)
		customers.append(character)
		add_child(character)
		SignalManager.emit_signal("customer_spawned", character)
		await get_tree().create_timer(1).timeout

func choose_customers(_number_customers) -> Array:
	# return [Helper.get_character("Green"), Helper.get_character("Blue"), Helper.get_character("Orange"), Helper.get_character("Salmon"), Helper.get_character("Red")]
	# return Helper.random_sample(Characters.list, _number_customers)
	return Characters.list

func on_customer_left(_customer):
	for i in len(customers):
		if customers[i].customer.character_name == _customer.customer.character_name:
			customers.remove_at(i)
			break
	if len(customers) == 0:
		SignalManager.emit_signal("store_closed")