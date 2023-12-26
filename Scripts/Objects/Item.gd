extends Area2D
class_name Item
@export var price: int = -1
@export var recipe: Recipe
@export var sold_price: int = -1
@export var id: int
var dragging = true
var can_drag = true
var can_place = false
var max_case_distance = 70
var label
signal on_mouse_event

func _ready():
	label = get_node("Label")
	connect("on_mouse_event", place_item)
	SignalManager.connect("store_opened", disable_drag)

func find_closest_case():
	var smallest_distance = 100000
	var closest_case
	for case in Data.store.display_cases:
		var d = distance(case)
		if d < smallest_distance:
			smallest_distance = d
			closest_case = case
	return closest_case

func distance(case):
	return sqrt((position.x - case.pos.x)**2 + (position.y - case.pos.y)**2)

func _process(_delta):
	if dragging:
		var mousepos = get_viewport().get_mouse_position()
		position = Vector2(mousepos.x, mousepos.y)

func _input(event):
	if event.is_action_pressed("ui_cancel"):
		if dragging:
			SignalManager.emit_signal("item_placement_cancelled", self)
			Helper.remove_item(Items.store, self)
			queue_free()

func place_item():
	var case = find_closest_case()
	if !dragging:
		dragging = true
		label.text = ""
		SignalManager.emit_signal("item_picked_up", case, self)
		return
	if case == null || distance(case) > max_case_distance || case.item != null:
		return
	dragging = false
	position = Vector2(case.pos.x, case.pos.y)
	SignalManager.emit_signal("item_placed", case, self)
	label.text = "$" + str(price)

func disable_drag():
	can_drag = false

func _input_event(_viewport, event, _shape_idx): #- if item is pressed specifically
	if event is InputEventMouseButton && event.pressed:
		if can_drag:
			emit_signal("on_mouse_event")

func _init(_recipe: Recipe = null, _price: int = -1) -> void: #- init when creating object, not for script
	price = _price
	recipe = _recipe
	id = Items.id
	Items.id += 1

func set_variables(_item: Item) -> void: #- when attaching script it copies another object 
	price = _item.price
	recipe = _item.recipe
	id = _item.id
	Items.store.append(self)

func dupe() -> Item:
	var item := Item.new(recipe)
	item.price = price
	item.sold_price = sold_price
	item.id = id
	return item

func equals(item: Item) -> bool:
	return id == item.id

func _to_string() -> String:
	if price == -1:
		return "%s $%s id: %s" % [recipe.recipe_name, recipe.base_price, id]
	else:
		return "%s $%s id: %s" % [recipe.recipe_name, price, id]
