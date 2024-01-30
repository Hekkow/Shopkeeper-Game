extends Node2D


@export var queue := Queue.new()
var face_direction = Vector2i(11, 2)
var interactable = false

func _ready():
	SignalManager.connect("level_ready", on_level_ready)
	SignalManager.connect("customer_reached_queue", on_customer_reached_queue)
	SignalManager.connect("customer_reached_table", on_customer_reached_table)
	SignalManager.connect("item_placed", on_item_placed)
	SignalManager.connect("store_opened", on_store_opened)

func on_level_ready(level):
	level.table = self
	interactable = level.any_display_case_full()

func on_customer_reached_table(_customer):
	interactable = true

func on_customer_reached_queue(character):
	if !queue.in_line(character):
		queue.add(character)

func interact():
	if Data.store.store_open:
		queue.get_first().haggle()
	else:
		SignalManager.emit_signal("store_table_interacted")
	interactable = false

func on_store_opened():
	interactable = false

func on_item_placed(_case, _item):
	interactable = Data.store.any_display_case_full()

func get_place(character):
	if queue.in_line(character):
		return face_direction + Vector2i(0, queue.place_in_line(character) + 1)
	else:
		return face_direction + Vector2i(0, queue.n + 1)

func current_place():
	return face_direction + Vector2i(0, queue.n)
