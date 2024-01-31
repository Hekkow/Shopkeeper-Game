extends Node

var list: Array
var inventory = Inventory.new()
var maximum = 10000

func _ready():
	list = Helper.get_resources("Recipes")
	SignalManager.connect("item_placed", on_item_placed)
	SignalManager.connect("item_picked_up", on_item_picked_up)
	SignalManager.connect("pot_pressed", add_to_inventory)
	inventory.add(find_recipe("Diddlin"), 6)
	inventory.add(find_recipe("Hurtin"), 6)

func check_recipes(_element: Element) -> Recipe:
	var minimum = maximum
	var values = []
	var element = _element.arr()
	for i in len(element):
		var amount = element[i]
		if amount < minimum and amount != 0:
			minimum = amount
	for i in len(element):
		values.append(float(element[i])/float(minimum))
	for recipe in Recipes.list:
		if recipe.recipe_equals(values):
			return recipe
	return null

func add_to_inventory(recipe):
	inventory.add(recipe)

func find_recipe(recipe_name) -> Recipe:
	for recipe in list:
		if recipe.recipe_name == recipe_name:
			return recipe
	return null

func on_item_placed(_case, item):
	var slot = inventory.find(item.recipe)
	if slot.subtract() == 0:
		inventory.remove(slot.object)
	# SignalManager.emit_signal("recipe_removed_from_inventory", slot)
	if len(inventory.inv) == 0:
		SignalManager.emit_signal("escape_recipe_to_item")

func on_item_picked_up(_case, item):
	inventory.add(item.recipe)
