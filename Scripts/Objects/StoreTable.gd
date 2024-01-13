extends Node2D


@export var queue := Queue.new()
var face_direction = Vector2i(11, 2)

func _ready():
	SignalManager.connect("store_initialized", on_store_initialized)
	SignalManager.connect("customer_reached_queue", on_customer_reached_queue)

func on_store_initialized():
	Data.store.table = self

func on_customer_reached_queue(character):
	queue.add(character)

func interact():
	queue.get_first().haggle()

func get_place(character):
	if queue.in_line(character):
		print(str(character) + " in queue " + str(face_direction) + str(Vector2i(0, queue.place_in_line(character) + 1)))
		return face_direction + Vector2i(0, queue.place_in_line(character) + 1)
	else:
		print(str(character) + " not in queue " + str(face_direction) + str(Vector2i(0, queue.n + 1)))
		return face_direction + Vector2i(0, queue.n + 1)

func current_place():
	return face_direction + Vector2i(0, queue.n)
