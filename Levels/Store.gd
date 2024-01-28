extends Level

class_name Store

var display_cases := []
var customers: Array = []
var store_open = false
var store_closing = false

var table

@export var number_customers: int


func _ready() -> void:
	solid_layers = [1, 2]
	Data.store = self
	SignalManager.connect("store_opened", on_store_opened)
	SignalManager.connect("price_set", spawn_item)	
	SignalManager.connect("customer_left", on_customer_left)
	SignalManager.connect("store_closing", on_store_closing)
	super()

func on_store_opened() -> void:
	store_open = true
	if len(Items.store) == 0:
		SignalManager.emit_signal("store_closed")
		return
	spawn_customers(number_customers)
	
func spawn_item(_item: Item) -> void:
	var item = Paths.item.instantiate()
	item.set_variables(_item)
	add_child(item)
	SignalManager.emit_signal("item_spawned", item)

func on_store_closing():
	store_closing = true

func spawn_customers(_number_customers: int) -> void:
	var _customers := choose_customers(_number_customers)
	for customer in _customers:
		if store_closing:
			return
		var character = Paths.character.instantiate()
		character.set_variables(customer)
		customers.append(character)
		add_child(character)
		SignalManager.emit_signal("customer_spawned", character)
		await get_tree().create_timer(1).timeout

func choose_customers(_number_customers) -> Array:
	return Characters.list.slice(0, _number_customers)

func on_customer_left(_customer):
	for i in len(customers):
		if customers[i].equals(_customer):
			customers.remove_at(i)
			break
	if len(customers) == 0:
		SignalManager.emit_signal("store_closed")

func any_display_case_full() -> bool:
	for case in display_cases:
		if case.item != null:
			return true
	return false
