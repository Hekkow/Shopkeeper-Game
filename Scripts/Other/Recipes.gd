extends Node

var list: Array
var inventory = Inventory.new()
var maximum = 10000

func _ready():
	list = Helper.get_resources("Recipes")
	SignalManager.connect("recipe_made", on_recipe_made)
	SignalManager.connect("item_placed", on_item_placed)

func check_recipes(_elements: Element) -> Recipe:
	var minimum = maximum
	var values = []
	var e = _elements.arr()
	for i in len(e):
		var amount = e[i]
		if amount < minimum and amount != 0:
			minimum = amount
	for i in len(e):
		values.append(float(e[i])/float(minimum))
	for recipe in Recipes.list:
		if recipe.recipe_equals(values):
			return recipe
	return null

func find_recipe(recipe_name) -> Recipe:
	for recipe in list:
		if recipe.recipe_name == name:
			return recipe
	return null

func on_recipe_made(recipe) -> void:
	inventory.add(recipe)

func on_item_placed(item):
	var slot = inventory.find(item.recipe)
	if slot.subtract() == 0:
		inventory.remove(slot.object)
	SignalManager.emit_signal("recipe_removed_from_inventory", slot)
	if len(inventory.inv) == 0:
		SignalManager.emit_signal("store_opened")