extends Node2D

class_name Character

@export var customer: CharacterStats
var speed = 3
var destination
var interested_item
var paused = false
var items_visited = []
var exit = Vector2(0, 0)
var label
var table
var table_position

func _init(_customer=null):
	customer = _customer

func _ready():
	label = get_node("Label")
	table = Data.all["Table"]
	table_position = table.get_position()
	SignalManager.connect("customer_interested", on_other_customer_interested)
	visit_random_item()
	
	
func visit_random_item():
	var found = false
	var item
	while !found:
		if Helper.len_without_deleted(items_visited) == len(Data.all["Store Items"]):
			leave_store()
			return
		item = Data.all["Store Items"][Data.all["Seed"].randi_range(0, len(Data.all["Store Items"]) - 1)]
		found = !items_visited.has(item)
	items_visited.append(item)
	interested_item = item.dupe()
	destination = item.get_position()
	item.area_entered.connect(Callable(on_item_visit).bind(item))

func interested(item):
	if customer.richness == Data.all["Max Richness"]:
		return true
	if customer.affinity.has(item.recipe):
		return true
	return Data.all["Seed"].randf() > 0.5

func on_item_visit(body, item):
	if body != self:
		return
	item.area_entered.disconnect(Callable(on_item_visit).bind(item))
	if !Data.all["Store Items"].has(item):
		visit_random_item()
		return
	pause(0.5)
	if interested(item):
		SignalManager.emit_signal("customer_interested", self, interested_item)
		Data.all["Store Items"].remove_at(Data.all["Store Items"].find(item))
		await get_tree().create_timer(0.5).timeout
		item.queue_free()
		destination = table_position
		table.area_entered.connect(on_table_visit)
	else:
		visit_random_item()

func on_other_customer_interested(_customer, item):
	if _customer == self:
		return
	if !item.equals(interested_item):
		return
	pause(0.5, 0.5)
	var current_destination = destination
	visit_random_item()
	var next_destination = destination
	destination = current_destination
	await get_tree().create_timer(0.5).timeout
	destination = next_destination
	# basically lets customer walk for 0.5s more then stops for 0.5s then changes direction

func find_item_visited(item):
	for i in range(len(items_visited)):
		if item.equals(items_visited[i]):
			return i
	return -1

func pause(seconds, seconds_before=0.0):
	await get_tree().create_timer(seconds_before).timeout
	paused = true
	await get_tree().create_timer(seconds).timeout
	paused = false

func on_table_visit(body):
	if body != self:
		return
	haggle(interested_item)

func haggle(item):
	pause(1)
	item.sold_price = item.recipe.base_price * 20
	buy(item)

func buy(item):
	SignalManager.emit_signal("item_sold", item)
	leave_store()

func _physics_process(_delta):
	if paused:
		return
	position += (destination - get_position()).normalized() * speed

func _to_string():
	return "%s\n$%s" % [customer.character_name]

func leave_store():
	destination = exit
