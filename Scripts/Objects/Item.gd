extends Area2D
class_name Item
@export var price: int = -1
@export var recipe: Recipe
@export var sold_price: int = -1
@export var id: int
var dragging = true
var can_drag = true
signal on_mouse_event

func _ready():
	connect("on_mouse_event", set_dragging)
	SignalManager.connect("store_opened", disable_drag)
	
func _process(_delta):
	if dragging:
		var mousepos = get_viewport().get_mouse_position()
		self.position = Vector2(mousepos.x, mousepos.y)

func _input(event):
	if event.is_action_pressed("ui_cancel"):
		if dragging:
			SignalManager.emit_signal("item_placement_cancelled", self)
			Helper.remove_item(Items.store, self)
			queue_free()

func set_dragging():
	dragging = !dragging
	if !dragging:
		SignalManager.emit_signal("item_placed", self)
		get_node("Label").text = "$" + str(price)
		

func disable_drag():
	can_drag = false

func _input_event(_viewport, event, _shape_idx): #- if item is pressed specifically
	if event is InputEventMouseButton && event.pressed && can_drag:
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
