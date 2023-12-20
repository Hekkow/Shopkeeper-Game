extends Node
class_name Item
@export var price = -1
@export var base_price: int
@export var recipe: Recipe
@export var sold_price = -1

func _init(_base_price=-1, _recipe=null):
	base_price = _base_price
	recipe = _recipe

func _ready():
	Data.all["Store Items"].append(self)

func dupe() -> Item:
	var item = Item.new(base_price, recipe)
	item.price = price
	item.sold_price = sold_price
	return item

func equals(item) -> bool:
	return recipe.equals(item.recipe) && base_price == item.base_price

func _to_string():
	if price == -1:
		return "%s $%s" % [recipe.recipeName, base_price]
	else:
		return "%s $%s" % [recipe.recipeName, price]
