extends Node
class_name Item
@export var price = -1
@export var recipe: Recipe
@export var sold_price = -1
@export var id: int

func _init(_recipe=null):
	recipe = _recipe
	id = Data.all["Item ID"]
	Data.all["Item ID"] += 1

func _ready():
	Data.all["Store Items"].append(self)

func dupe() -> Item:
	var item = Item.new(recipe)
	item.price = price
	item.sold_price = sold_price
	item.id = id
	return item

func equals(item) -> bool:
	return id == item.id

func _to_string():
	if price == -1:
		return "%s $%s id: %s" % [recipe.recipe_name, recipe.base_price, id]
	else:
		return "%s $%s id: %s" % [recipe.recipe_name, price, id]
