extends Node2D

class_name Character

@export var customer: CharacterStats
@export var debug_draw = true
@onready var collision_shape = $CollisionShape2D
var speed := 3
var interested_item: Item
var interested_item_node: Node
var paused := false
var haggling_paused := false
var priority_queue := []
@onready var store = Data.store
@onready var exit = Vector2(11, 10)

@onready var animated_sprite = $AnimatedSprite2D

enum State { LOOKING, BUYING, LEAVING }
var state: State
var path: Array
var min_distance := 3

func _init(_customer: CharacterStats = null) -> void:
	customer = _customer

func _ready() -> void:
	if GameState.state == GameState.State.Shopping:
		set_physics_process(false)
		position = store.tilemap.map_to_local(exit) - collision_shape.global_transform.origin
		SignalManager.connect("customer_interested", on_other_customer_interested)
		SignalManager.connect("haggling_started", on_haggling_started)
		SignalManager.connect("haggling_ended", on_haggling_ended)
		SignalManager.connect("customer_reached_queue", on_customer_reached_queue)
		priority_queue = get_priorities()
		visit_random_item()
	elif GameState.state == GameState.State.World:
		pass

func interact():
	var conversation = load("res://Scenes/UI/TextBubbles/Conversation.tscn").instantiate()
	conversation.initialize_position(position + Vector2(0, -80))
	conversation.initialize_text_tree("Black-test")
	get_parent().add_child(conversation)

func get_priorities() -> Array:
	var priorities = []
	for item in Items.store:
		var prio = 0
		if Helper.find_index(customer.affinity, item.recipe) != -1:
			prio += 100
		prio -= customer.personality.diff(item.recipe.element)
		priorities.append(Priority.new(item, prio))
	PriorityList.sort(priorities)
	var items = []
	for item in priorities:
		items.append(item.obj)
	return items

func get_next_priority() -> Item:
	# return priority_queue[Data.rng.randi_range(0, len(priority_queue) - 1)]
	return priority_queue[0]

func visit_random_item() -> void:
	if !priority_queue:
		leave_store()
		return
	interested_item_node = get_next_priority()
	interested_item = interested_item_node.dupe() #- new item without the node
	set_destination_path(store.get_corresponding_case(interested_item), State.LOOKING)

func interested(_item: Item) -> bool:
	return Data.rng.randf() <= 1

func on_item_reached():
	pause(0.5)
	if GameState.state == GameState.State.Haggling:
		await SignalManager.haggling_done
	if interested(interested_item):
		SignalManager.emit_signal("customer_interested", self, interested_item)
		await get_tree().create_timer(0.5).timeout
		interested_item_node.queue_free()
		set_destination_path(Data.store.table.current_position, State.BUYING)
	else:
		Helper.remove(priority_queue, interested_item)
		visit_random_item()

func haggle() -> void:
	SignalManager.emit_signal("haggling_started", self)
	

func on_haggling_started(_customer):
	haggling_stop()

func on_haggling_ended(_customer, score_multiplier):
	if _customer == self:
		interested_item.sold_price = int(interested_item.price * score_multiplier)
		buy()
	haggling_start()
	

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
	Helper.remove(priority_queue, item)
	if _customer == self || !item.equals(interested_item):
		return
	visit_random_item()

func on_customer_reached_queue(character: Character):
	if character == self:
		return
	if (len(path) > 0):
		print(path)
		print(str(path[len(path)-1]) + " == " + str(Data.store.table.current_position - Vector2i(0, 1)))
	if len(path) > 0 && path[len(path)-1] == Data.store.table.current_position - Vector2i(0, 1):
		set_destination_path(Data.store.table.current_position, state)



func pause(seconds: float) -> void:
	stop()
	await get_tree().create_timer(seconds).timeout
	start()

func stop():
	animated_sprite.stop()
	paused = true

func haggling_stop():
	animated_sprite.stop()
	haggling_paused = true

func start():
	paused = false

func haggling_start():
	haggling_paused = false

func set_destination_path(destination: Vector2, _state: State):
	state = _state
	path = get_shortest_path(store.tilemap.local_to_map(collision_shape.global_transform.origin), destination)
	set_physics_process(true)
	
func get_shortest_path(_start: Vector2, destination: Vector2) -> Array:
	if !store.astar.is_point_solid(destination):
		return store.astar.get_id_path(_start, destination)
	var shortest_path = store.astar.get_id_path(_start, store.tilemap.get_neighbor_cell(destination, 0))
	for i in range(4, 12+1, 4):
		var neighbor_cell = store.tilemap.get_neighbor_cell(destination, i)
		if store.astar.is_point_solid(neighbor_cell):
			continue
		var neighbor_path = store.astar.get_id_path(_start, neighbor_cell)
		if len(shortest_path) == 0 || len(neighbor_path) < len(shortest_path):
			shortest_path = neighbor_path
	return shortest_path 

func get_empty_block(destination: Vector2):
	var cell = store.tilemap.local_to_map(destination)
	if !store.astar.is_point_solid(cell):
		return cell
	for i in range(0, 12+1, 4):
		var coords = store.tilemap.get_neighbor_cell(cell, i)
		if !store.astar.is_point_solid(coords):
			return coords

func _draw():
	if !debug_draw || len(path) == 0:
		return
	var last = store.tilemap.map_to_local(path[0]) - position
	for i in len(path)-1:
		var from = store.tilemap.map_to_local(path[i])
		var to = store.tilemap.map_to_local(path[i+1])
		draw_line(last, last + to - from, customer.color)
		last += to - from

func _physics_process(_delta):
	if paused || haggling_paused || len(path) == 0:
		return
	if debug_draw:
		queue_redraw()
	var next_point = store.tilemap.map_to_local(path[0])
	var pos = collision_shape.global_transform.origin
	look_direction(next_point)
	var distance = pos.distance_to(next_point)
	if distance < min_distance: #- if reached point
		path.remove_at(0)
		if len(path) == 0:
			set_physics_process(false)
			destination_reached()
			return
		next_point = store.tilemap.map_to_local(path[0])
	var dir = (next_point - pos).normalized()
	position += dir * speed

func look_direction(to):
	var direction = to - collision_shape.global_transform.origin
	match Helper.cardinal_direction(direction):
		Helper.Direction.UP:
			animated_sprite.play("up")
		Helper.Direction.DOWN:
			animated_sprite.play("down")
		Helper.Direction.LEFT:
			animated_sprite.play("side")
			animated_sprite.flip_h = true
		Helper.Direction.RIGHT:
			animated_sprite.play("side")
			animated_sprite.flip_h = false

func destination_reached():
	if state == State.LOOKING:
		look_direction(interested_item_node.position)
		on_item_reached()
	elif state == State.BUYING:
		look_direction(store.tilemap.map_to_local(Data.store.table.face_direction))
		SignalManager.emit_signal("customer_reached_queue", self)
		# haggle()
	elif state == State.LEAVING:
		on_reached_door()
	animated_sprite.stop()

func _to_string() -> String:
	return customer.character_name

func equals(character: Character) -> bool:
	return customer.character_name == character.customer.character_name
		
