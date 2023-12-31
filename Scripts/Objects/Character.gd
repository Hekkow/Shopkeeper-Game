extends Node2D

class_name Character

@export var customer: CharacterStats
@export var debug_draw = false
@onready var collision_shape = $CollisionShape2D
var speed := 3
var interested_item: Item
var interested_item_node: Node
var paused := false
var priority_queue := []
var exit: Vector2
var table_position: Vector2
var store: Node
enum State { LOOKING, BUYING, LEAVING }
var state: State
var path: Array
var min_distance := 3

func _init(_customer: CharacterStats = null) -> void:
	customer = _customer

func _ready() -> void:
	set_physics_process(false)
	store = Data.store
	exit = store.door.position
	position = exit
	table_position = store.table.position
	priority_queue = get_priorities()
	SignalManager.connect("customer_interested", on_other_customer_interested)
	visit_random_item()

func get_priorities() -> Array:
	var priorities = []
	for item in Items.store:
		var prio = 0
		if Helper.find_item(customer.affinity, item.recipe) != -1:
			prio += 100
		prio -= customer.personality.diff(item.recipe.element)
		priorities.append(Priority.new(item, prio))
	PriorityList.sort(priorities)
	var items = []
	for item in priorities:
		items.append(item.obj)
	return items

func get_next_priority() -> Item:
	return priority_queue[Data.rng.randi_range(0, len(priority_queue) - 1)]
	# return priority_queue[0]

func visit_random_item() -> void:
	if !priority_queue:
		leave_store()
		return
	interested_item_node = get_next_priority()
	interested_item = interested_item_node.dupe() #- new item without the node
	set_destination_path(interested_item_node.position, State.LOOKING)

func interested(_item: Item) -> bool:
	return Data.rng.randf() <= 0.3

func on_item_reached():
	pause(0.5)
	if interested(interested_item):
		SignalManager.emit_signal("customer_interested", self, interested_item)
		await get_tree().create_timer(0.5).timeout
		interested_item_node.queue_free()
		set_destination_path(table_position, State.BUYING)
	else:
		Helper.remove_item(priority_queue, interested_item)
		visit_random_item()

func haggle() -> void:
	pause(1)
	interested_item.sold_price = int(interested_item.price * 1.2)
	buy()

func buy() -> void:
	SignalManager.emit_signal("item_sold", interested_item)
	leave_store()

func leave_store() -> void:
	set_destination_path(exit, State.LEAVING)
	SignalManager.disconnect("customer_interested", on_other_customer_interested)

func on_reached_door():
	SignalManager.emit_signal("customer_left", self)
	queue_free()

func on_other_customer_interested(_customer: Character, item: Item) -> void:
	Helper.remove_item(priority_queue, item)
	if _customer == self || !item.equals(interested_item):
		return
	visit_random_item()

func pause(seconds: float) -> void:
	paused = true
	await get_tree().create_timer(seconds).timeout
	paused = false

func set_destination_path(destination: Vector2, _state: State):
	state = _state
	var from = store.tilemap.local_to_map(collision_shape.global_transform.origin)
	var to = get_empty_block(destination)
	print(store)
	path = store.astar.get_id_path(from, to)
	set_physics_process(true)

func get_empty_block(destination: Vector2):
	var last_point = store.tilemap.local_to_map(destination)
	if !store.astar.is_point_solid(last_point):
		return last_point
	var cell = store.tilemap.local_to_map(destination)
	cell.y += 1
	for i in range(0, 12+1, 4):
		var coords = store.tilemap.get_neighbor_cell(cell, i)
		print(coords)
		if !store.astar.is_point_solid(coords):
			last_point = coords
			return last_point

func _draw():
	if !debug_draw || len(path) == 0:
		return
	var last = store.tilemap.map_to_local(path[0]) - position
	for i in len(path)-1:
		var from = store.tilemap.map_to_local(path[i])
		var to = store.tilemap.map_to_local(path[i+1])
		draw_line(last, last + to - from, customer.color)
		last += to - from

func _physics_process(_delta: float):
	if paused || len(path) == 0:
		return
	if debug_draw:
		queue_redraw()
	var next_point = store.tilemap.map_to_local(path[0])
	var pos = collision_shape.global_transform.origin
	var distance = pos.distance_to(next_point)
	if distance < min_distance:
		path.remove_at(0)
		if len(path) == 0:
			set_physics_process(false)
			destination_reached()
			return
		next_point = store.tilemap.map_to_local(path[0])
	var dir = (next_point - pos).normalized()
	position += dir * speed

func destination_reached():
	if state == State.LOOKING:
		on_item_reached()
	elif state == State.BUYING:
		haggle()
	elif state == State.LEAVING:
		on_reached_door()

func _to_string() -> String:
	return customer.character_name


		
