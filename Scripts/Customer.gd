extends Node2D

class_name Customer

@export var character_name: String
@export var money: int
@export var speed: int
var destination
var interested_item
var paused = false
var items_visited = []
var exit = Vector2(0, 0)

func _init(_character_name="", _money=0):
	character_name = _character_name
	money = _money

func _ready():
	SignalManager.connect("customer_took_item", on_customer_took_item)
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

func interested(_item):
	return Data.all["Seed"].randf() > 0.5

func on_item_visit(body, item):
	if body != self:
		return
	if !Data.all["Store Items"].has(item):
		item.area_entered.disconnect(Callable(on_item_visit).bind(item))
		visit_random_item()
		return
	pause(0, 0.5)
	item.area_entered.disconnect(Callable(on_item_visit).bind(item))
	if interested(item):
		SignalManager.emit_signal("customer_interested", self, interested_item)
		Data.all["Store Items"].remove_at(Data.all["Store Items"].find(item))
		await get_tree().create_timer(0.5).timeout
		item.queue_free()
		var table = Data.all["Table"]
		destination = table.get_position()
		table.area_entered.connect(on_table_visit)
		SignalManager.emit_signal("customer_took_item", self, interested_item)
	else:
		visit_random_item()
	
func on_customer_took_item(customer, item):
	if customer == self:
		return
	if !item.equals(interested_item):
		return

func on_other_customer_interested(customer, item):
	if customer == self:
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

	

func find_item_visited(item):
	for i in range(len(items_visited)):
		if item.equals(items_visited[i]):
			return i
	return -1

func pause(seconds_before, seconds_during):
	await get_tree().create_timer(seconds_before).timeout
	paused = true
	await get_tree().create_timer(seconds_during).timeout
	paused = false

func on_table_visit(body):
	if body != self:
		return
	haggle(interested_item)

func haggle(item):
	pause(0, 1)
	buy(item)

func buy(item):
	money -= item.sold_price
	SignalManager.emit_signal("item_sold", self, item)
	leave_store()

func _physics_process(_delta):
	# print(items_visited)
	get_node("Label").text = str(items_visited)
	if !paused:
		position += (destination - get_position()).normalized() * speed

func _to_string():
	return "%s\n$%s" % [character_name, money]

func leave_store():
	destination = exit
