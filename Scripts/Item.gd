extends Resource
class_name Item
@export var price = -1
@export var base_price: int
@export var recipe: Recipe
@export var sold_price = -1

func _init(_base_price, _recipe=null):
	base_price = _base_price
	recipe = _recipe

func _to_string():
	if price == -1:
		return "%s $%s" % [recipe.recipeName, base_price]
	else:
		return "%s $%s" % [recipe.recipeName, price]