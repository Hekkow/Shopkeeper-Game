extends Node2D
class_name Item
@export var price: int = -1
@export var recipe: Recipe
@export var sold_price: int = -1
@export var id: int

@onready var label = $Label

func _ready():
	SignalManager.connect("item_placed", on_item_placed)
	SignalManager.connect("item_picked_up", on_item_picked_up)

func on_item_placed(_case, item):
	if item != self:
		return
	label.text = "$" + str(price)
	
func on_item_picked_up(_case, item):
	if item != self:
		return
	label.text = ""

func _init(_recipe: Recipe = null, _price: int = -1):
	if _recipe == null:
		return
	price = _price
	if _price == -1:
		price = _recipe.base_price
	recipe = _recipe
	id = Items.id
	Items.id += 1

func set_variables(_item: Item): #- when attaching script it copies another object 
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
