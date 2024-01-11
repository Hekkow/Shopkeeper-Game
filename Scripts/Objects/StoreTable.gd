extends Node2D


var queue := Queue.new()
var face_direction = Vector2i(11, 2)
var current_position = Vector2i(11, 3)

func _ready():
	SignalManager.connect("store_initialized", on_store_initialized)
	SignalManager.connect("customer_reached_queue", on_customer_reached_queue)

func on_store_initialized():
	Data.store.table = self

func on_customer_reached_queue(character):
	print("HERE")
	queue.add(character)
	current_position.y += 1
