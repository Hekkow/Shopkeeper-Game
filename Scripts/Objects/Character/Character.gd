extends Node2D

class_name Character

@export var customer: CharacterStats
@onready var pathfinding = $Pathfinding

var interested_item: Item
var interested_item_node: Node

var priority_queue := []
@onready var store = Data.store
@onready var animated_sprite = $AnimatedSprite2D
var interactable = true


enum State { LOOKING, LINE, BUYING, LEAVING }
@export var state: State


func _init(_customer: CharacterStats = null):
	customer = _customer

func _ready():
	Characters.active.append(self)
	add_to_group("customers")
	if GameState.state == GameState.State.Shopping:
		get_priority_queue()
		SignalManager.connect("customer_interested", on_other_customer_interested)
		SignalManager.connect("haggling_ended", on_haggling_ended)
		SignalManager.connect("customer_reached_queue", on_customer_reached_queue)
		SignalManager.connect("customer_leaving_line", on_customer_leaving_line)
		visit_random_item()
	elif GameState.state == GameState.State.World:
		pass

func interact():
	var conversation = load("res://Scenes/UI/TextBubbles/Conversation.tscn").instantiate()
	conversation.init(position + Vector2(0, -80), "Black-convo")
	get_parent().add_child(conversation)
	print(str(self) + " interacted")

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

func go_to(_state, item=null):
	state = _state
	pathfinding.go_to(state, item)
	
func destination_reached():
	if state == State.LOOKING:
		pathfinding.look_direction(interested_item_node.position)
		on_item_reached()
	elif state == State.LINE:
		pathfinding.look_direction(store.tilemap.map_to_local(Data.store.table.face_direction))
		SignalManager.emit_signal("customer_reached_queue", self)
		if store.table.queue.place_in_line(self) == 0:
			SignalManager.emit_signal("customer_reached_table", self)
	elif state == State.LEAVING:
		remove_from_group("customers")
		SignalManager.emit_signal("customer_left", self)
		queue_free()

	stop_animation()

func interested(_item: Item) -> bool:
	return Data.rng.randf() <= 1

func on_item_reached():
	# pause(0.5)
	if GameState.state == GameState.State.Haggling:
		await SignalManager.haggling_done
	if interested(interested_item):
		SignalManager.emit_signal("customer_interested", self, interested_item)
		await get_tree().create_timer(0.5).timeout
		interested_item_node.queue_free()
		go_to(State.LINE)
	else:
		Helper.remove(priority_queue, interested_item)
		visit_random_item()

func haggle():
	get_tree().call_group("customers", "haggling_pause")
	SignalManager.emit_signal("haggling_started", self)
	
func haggling_pause():
	pathfinding.haggling_pause()

func haggling_resume():
	pathfinding.haggling_resume()

func on_other_customer_interested(_customer: Character, item: Item):
	Helper.remove(priority_queue, item)
	if _customer == self || !item.equals(interested_item):
		return
	visit_random_item()

func on_customer_reached_queue(character: Character):
	if character == self:
		return
	if store.table.queue.place_in_line(self) != -1 && store.table.queue.place_in_line(character) > store.table.queue.place_in_line(self):
		return
	if state == State.LINE:
		go_to(State.LINE)

func on_customer_leaving_line(character: Character):
	if character == self:
		return
	if state == State.LINE:
		go_to(State.LINE)

func on_haggling_ended(_customer, score_multiplier):
	if _customer == self:
		interested_item.sold_price = int(interested_item.price * score_multiplier)
		SignalManager.emit_signal("customer_leaving_line", self)
		SignalManager.emit_signal("item_sold", interested_item)
		leave_store()

func leave_store():
	go_to(State.LEAVING)
	SignalManager.disconnect("customer_interested", on_other_customer_interested)

func stop_animation():
	animated_sprite.stop()

func walk_animation(direction):
	match direction:
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



func _to_string() -> String:
	return customer.character_name

func equals(character: Character) -> bool:
	return customer.character_name == character.customer.character_name
		
