extends Node2D


@export var queue := Queue.new()
var face_direction = Vector2i(11, 2)
var interactable = false

func _ready():
	SignalManager.connect("store_initialized", on_store_initialized)
	SignalManager.connect("customer_reached_queue", on_customer_reached_queue)
	SignalManager.connect("customer_reached_table", on_customer_reached_table)

func on_store_initialized():
	Data.store.table = self

func on_customer_reached_table(_customer):
	interactable = true

func on_customer_reached_queue(character):
	if !queue.in_line(character):
		queue.add(character)

func interact():
	queue.get_first().haggle()
	interactable = false

func get_place(character):
	if queue.in_line(character):
		return face_direction + Vector2i(0, queue.place_in_line(character) + 1)
	else:
		return face_direction + Vector2i(0, queue.n + 1)

func current_place():
	return face_direction + Vector2i(0, queue.n)
