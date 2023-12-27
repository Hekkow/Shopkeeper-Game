extends Node2D

class_name Character

@export var customer: CharacterStats 
#- easier to make new characters by having the stats themselves in another file
#- also just for now we cant have this file be a resource cuz position wont work
var speed: int = 3
var destination: Vector2
var interested_item: Item
var paused = false
var priority_queue: Array = []
var exit: Vector2 = Data.store.door.position
var table_position: Vector2
var left_door = false

func _init(_customer: CharacterStats = null) -> void:
	customer = _customer

func _ready() -> void:
	position = Data.store.door.position
	table_position = Data.store.table.position
	priority_queue = get_priorities()
	SignalManager.connect("customer_interested", on_other_customer_interested)
	Data.store.door.area_exited.connect(on_door_left)
	visit_random_item()

func on_door_left(_body):
	left_door = true

func visit_random_item() -> void:
	if !priority_queue:
		leave_store()
		return
	var item = get_next_priority()
	interested_item = item.dupe() #- need a new item with the same stats so that we can have interested item exist even if something happens to original
	destination = item.position
	item.area_entered.connect(Callable(on_item_visit).bind(item))

func get_next_priority() -> Item:
	return priority_queue[Data.rng.randi_range(0, len(priority_queue) - 1)]
	# return priority_queue[0]

func get_priorities() -> Array:
	var priorities = []
	for item in Items.store:
		var prio = 0
		if Helper.find_item(customer.affinity, item.recipe) != -1: #- if has affinity with item
			prio += 100
		prio -= customer.personality.diff(item.recipe.element)
		priorities.append(Priority.new(item, prio))
	PriorityList.sort(priorities)
	var items = []
	for item in priorities:
		items.append(item.obj)
	return items

func interested(_item: Item) -> bool:
	# if customer.richness == Characters.max_richness:
	# 	return true
	# if customer.affinity.has(item.recipe):
	# 	return true
	return Data.rng.randf() < 1

func on_item_visit(body, item: Item) -> void:
	if body != self:
		return
	if !item.equals(interested_item):
		return
	item.area_entered.disconnect(Callable(on_item_visit).bind(item))
	pause(0.5)
	if interested(item):
		SignalManager.emit_signal("customer_interested", self, item)
		await get_tree().create_timer(0.5).timeout
		item.queue_free()
		destination = table_position
		Data.store.table.area_entered.connect(on_table_visit)
	else:
		Helper.remove_item(priority_queue, item)
		visit_random_item()

func on_other_customer_interested(_customer: Character, item: Item) -> void:
	Helper.remove_item(priority_queue, item)
	if _customer == self:
		return
	if !item.equals(interested_item):
		return
	visit_random_item()

func pause(seconds: float) -> void:
	paused = true
	await get_tree().create_timer(seconds).timeout
	paused = false

func on_table_visit(body: Character) -> void:
	if body != self:
		return
	haggle(interested_item)

func haggle(item: Item) -> void:
	pause(1)
	item.sold_price = int(item.price * 1.2)
	buy(item)

func buy(item: Item) -> void:
	SignalManager.emit_signal("item_sold", item)
	leave_store()

func _physics_process(_delta: float):
	if paused:
		return
	position += (destination - position).normalized() * speed

func _to_string() -> String:
	return customer.character_name
	# return "%s\n$%s" % [customer.character_name]

func leave_store() -> void:
	destination = exit
	SignalManager.disconnect("customer_interested", on_other_customer_interested)
	if !left_door:
		on_reached_door(self)
		return
	Data.store.door.area_entered.connect(on_reached_door)

func on_reached_door(body):
	if body != self:
		return
	SignalManager.emit_signal("customer_left", self)
	queue_free()
		
