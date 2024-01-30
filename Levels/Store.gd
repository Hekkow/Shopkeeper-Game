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
	SignalManager.connect("store_table_interacted", open_store)
	SignalManager.connect("customer_left", on_customer_left)
	SignalManager.connect("store_items_depleted", store_is_closing)
	SignalManager.connect("item_created", spawn_item)
	super()

func open_store() -> void:
	if len(Items.store) == 0:
		return
	SignalManager.emit_signal("store_opened")
	store_open = true
	spawn_customers()
	
func store_is_closing():
	store_closing = true

func spawn_item(_item: Item):
	var item = Paths.item.instantiate()
	item.set_variables(_item)
	add_child(item)
	SignalManager.emit_signal("item_spawned", item)

func spawn_customers() -> void:
	var _customers := Characters.list.slice(0, number_customers)
	for customer in _customers:
		if store_closing:
			return
		var character = Paths.character.instantiate()
		character.set_variables(customer)
		customers.append(character)
		add_child(character)
		await get_tree().create_timer(1).timeout

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
