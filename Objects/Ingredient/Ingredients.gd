extends Node

var list: Array
var inventory = Inventory.new()

func _ready():
	list = Helper.get_resources("Ingredients")
	for i in list:
		inventory.add(i, 30)
	SignalManager.connect("bought_item", on_item_bought)
	SignalManager.connect("ingredient_added_to_pot", remove_from_inventory)
	SignalManager.connect("craft_menu_closed", readd_to_inventory)
	SignalManager.connect("ingredient_picked_up", add_ingredient_object)

func readd_to_inventory(pot):
	inventory.add_inventory(pot)

func on_item_bought(item):
	if not item is Ingredient:
		return
	inventory.add(item)

func add(ingredient, amount=1):
	for i in list:
		if ingredient == i.ingredient_name:
			inventory.add(i, amount)
func add_ingredient_object(ingredient, _pos=Vector2.ZERO):
	add(ingredient.ingredient_name)
func remove_from_inventory(ingredient):
	inventory.remove(ingredient, 1)

func get_random():
	return list[randi() % list.size()]