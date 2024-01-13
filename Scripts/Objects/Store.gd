extends Node2D

class_name Store

var item_scene: Resource
var character_scene: Resource
var item_class: Resource
var display_cases: Dictionary
var customers = []
var store_open = false
var tilemap: TileMap
var astar
var table
@export var number_customers: int


func _ready() -> void:
	Data.store = self
	item_scene = load("res://Scenes/Objects/Item.tscn")
	character_scene = load("res://Scenes/Objects/Character.tscn")
	item_class = load("res://Scripts/Objects/Item.gd")
	SignalManager.connect("store_opened", on_store_opened)
	SignalManager.connect("price_set", spawn_item)	
	SignalManager.connect("customer_left", on_customer_left)
	SignalManager.connect("store_closing", on_store_closing)
	SignalManager.emit_signal("store_initialized")

func on_store_opened() -> void:
	store_open = true
	if len(Items.store) == 0:
		SignalManager.emit_signal("store_closed")
		return
	spawn_customers(number_customers)

func spawn_item(_item: Item) -> void:
	var item = item_scene.instantiate()
	item.set_script(item_class)
	item.set_variables(_item)
	add_child(item)
	SignalManager.emit_signal("item_spawned", item)

func on_store_closing():
	store_open = false

func spawn_customers(_number_customers: int) -> void:
	var _customers := choose_customers(_number_customers)
	for customer in _customers:
		if !store_open:
			return
		if GameState.state == GameState.State.Haggling:
			await SignalManager.haggling_done
		var character = character_scene.instantiate()
		character.name = customer.character_name
		character.get_node("AnimatedSprite2D").modulate = customer.color
		character._init(customer)
		customers.append(character)
		add_child(character)
		SignalManager.emit_signal("customer_spawned", character)
		await get_tree().create_timer(1).timeout

func choose_customers(_number_customers) -> Array:
	# return [Helper.get_character("Green"), Helper.get_character("Blue"), Helper.get_character("Orange"), Helper.get_character("Salmon"), Helper.get_character("Red")]
	# return Helper.random_sample(Characters.list, _number_customers)
	# return Characters.list
	return Characters.list.slice(0, _number_customers)

func on_customer_left(_customer):
	for i in len(customers):
		if customers[i].customer.character_name == _customer.customer.character_name:
			customers.remove_at(i)
			break
	if len(customers) == 0:
		SignalManager.emit_signal("store_closed")

func get_corresponding_case(item: Item):
	for i in display_cases:
		if display_cases[i].item != null && display_cases[i].item.equals(item):
			return i
