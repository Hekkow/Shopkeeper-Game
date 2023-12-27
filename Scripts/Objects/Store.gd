extends Node2D

class_name Store

var item_scene
var character_scene
var item_class
var display_cases = []
var door
var table

func _ready() -> void:
	Data.store = self
	SignalManager.connect("store_opened", on_store_opened)
	SignalManager.connect("price_set", spawn_item)
	item_scene = load("res://Scenes/Objects/Item.tscn")
	character_scene = load("res://Scenes/Objects/Character.tscn")
	item_class = load("res://Scripts/Objects/Item.gd")
	SignalManager.emit_signal("store_initialized")

func on_store_opened() -> void:
	spawn_customers(1)

func spawn_item(_item: Item) -> void:
	var item = item_scene.instantiate()
	item.set_script(item_class)
	item.set_variables(_item)
	add_child(item)

func spawn_customers(number_customers: int) -> void:
	var customers := choose_customers(number_customers)
	for customer in customers:
		var character = character_scene.instantiate()
		character.name = customer.character_name
		character.get_node("Sprite2D").modulate = customer.color
		character._init(customer)
		character.set_position(door.position)
		add_child(character)
		SignalManager.emit_signal("customer_spawned", character)
		await get_tree().create_timer(1).timeout

func choose_customers(_number_customers) -> Array:
	# return [Helper.get_character("Green"), Helper.get_character("Blue"), Helper.get_character("Orange"), Helper.get_character("Salmon"), Helper.get_character("Red")]
	# return Helper.random_sample(Characters.list, _number_customers)
	return Characters.list

