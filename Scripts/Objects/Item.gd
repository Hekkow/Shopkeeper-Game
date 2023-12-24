extends Area2D
class_name Item
@export var price: int = -1
@export var recipe: Recipe
@export var sold_price: int = -1
@export var id: int
var dragging = true
var can_drag = true
signal on_mouse_event;


func _ready():
	connect("on_mouse_event", set_drag)
	SignalManager.connect("store_opened", on_store_opened)
	
func _process(_delta):
	if dragging:
		var mousepos = get_viewport().get_mouse_position()
		self.position = Vector2(mousepos.x, mousepos.y)

func set_drag():
	dragging=!dragging
	if !dragging:
		SignalManager.emit_signal("item_placed", self)

func on_store_opened():
	can_drag = false

func _input_event(_viewport, event, _shape_idx):
	if event is InputEventMouseButton && event.pressed && can_drag:
		emit_signal("on_mouse_event")

func _init(_recipe: Recipe = null, _price: int = -1) -> void:
	price = _price
	recipe = _recipe
	id = Data.all["Item ID"]
	Data.all["Item ID"] += 1

func set_variables(_recipe: Recipe, _price: int, _id: int = -1) -> void:
	price = _price
	recipe = _recipe
	if _id != -1:
		id = _id
	Data.all["Store Items"].append(self)

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
