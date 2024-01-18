extends Node

var priority_queue := []
var interested_item: Item
var interested_item_node: Node
@onready var parent = get_parent()
@onready var pathfinding = get_node("../Pathfinding")
@onready var store = Data.store
enum State { LOOKING, LINE, BUYING, LEAVING }
@export var state: State

func start():
	get_priority_queue()
	SignalManager.connect("customer_interested", on_other_customer_interested)
	SignalManager.connect("haggling_ended", on_haggling_ended)
	SignalManager.connect("customer_reached_queue", on_customer_reached_queue)
	SignalManager.connect("customer_leaving_line", on_customer_leaving_line)
	visit_random_item()

func get_priority_queue():
	priority_queue = Items.store

func get_next_priority() -> Item:
	# return priority_queue[Data.rng.randi_range(0, len(priority_queue) - 1)]
	return priority_queue[0]

func visit_random_item():
	if !priority_queue:
		leave_store()
		return
	interested_item_node = get_next_priority()
	interested_item = interested_item_node.dupe() #- new item without the node
	go_to(State.LOOKING, interested_item)

func interested(_item: Item) -> bool:
	return Data.rng.randf() <= 1

func on_item_reached():
	if interested(interested_item):
		SignalManager.emit_signal("customer_interested", parent, interested_item)
		await get_tree().create_timer(0.5).timeout
		interested_item_node.queue_free()
		go_to(State.LINE)
	else:
		Helper.remove(priority_queue, interested_item)
		visit_random_item()

func destination_reached():
	if state == State.LOOKING:
		pathfinding.look_direction(interested_item_node.position)
		on_item_reached()
	elif state == State.LINE:
		pathfinding.look_direction(store.tilemap.map_to_local(Data.store.table.face_direction))
		SignalManager.emit_signal("customer_reached_queue", parent)
		if store.table.queue.place_in_line(parent) == 0:
			SignalManager.emit_signal("customer_reached_table", parent)
	elif state == State.LEAVING:
		SignalManager.emit_signal("customer_left", parent)
		parent.queue_free()

func go_to(_state, item=null):
	state = _state
	pathfinding.go_to(state, item)
	
func haggle():
	SignalManager.emit_signal("haggling_started", parent)

func on_other_customer_interested(_customer: Character, item: Item):
	Helper.remove(priority_queue, item)
	if _customer == parent || !item.equals(interested_item):
		return
	visit_random_item()

func on_customer_reached_queue(character: Character):
	if character == parent:
		return
	if store.table.queue.place_in_line(parent) != -1 && store.table.queue.place_in_line(character) > store.table.queue.place_in_line(parent):
		return
	if state == State.LINE:
		go_to(State.LINE)

func on_customer_leaving_line(character: Character):
	if character == parent:
		return
	if state == State.LINE:
		go_to(State.LINE)

func on_haggling_ended(_customer, score_multiplier):
	if _customer == parent:
		interested_item.sold_price = int(interested_item.price * score_multiplier)
		SignalManager.emit_signal("customer_leaving_line", parent)
		SignalManager.emit_signal("item_sold", interested_item)
		leave_store()

func leave_store():
	go_to(State.LEAVING)
	SignalManager.disconnect("customer_interested", on_other_customer_interested)
