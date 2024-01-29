extends Node

var list: Array
var inventory = Inventory.new()
var pot = Inventory.new()

func _ready():
	list = Helper.get_resources("Ingredients")
	for i in list:
		inventory.add(i, 30)
	SignalManager.connect("bought_item", on_item_bought)

func on_item_bought(item):
	if not item is Ingredient:
		return
	inventory.add(item)

func add(ingredient, amount):
	for i in list:
		if ingredient == i.ingredient_name:
			inventory.add(i, amount)