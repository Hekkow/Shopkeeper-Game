extends Node

var all = {
	"Player" = {
		"money" = 0
	},
	"Ingredients" = [],
	"Recipes" = [],
	"Recipe Inventory" = [],
	"Ingredient Inventory" = [],
	"Characters" = [],
	"Pot Ingredients" = [],
	"Store Items Before" = [],
	"Store Items" = [],
	"Max Richness" = 5,
	"Max Friendship" = 5,
	"Item ID" = 0,
}
func _ready() -> void:
	all["Recipes"] = Helper.get_resources("Recipes")
	all["Characters"] = Helper.get_resources("Characters")
	all["Ingredients"] = Helper.get_resources("Ingredients")
	initialize_recipes()
	initialize_ingredient_inventory()
	initialize_seed()

func initialize_ingredient_inventory() -> void:
	for i in all["Ingredients"]:
		add_to_inventory("Ingredient Inventory", i, 10)

func add_to_inventory(inventory: String, item: Object, amount: int = 1) -> void:
	var index := inventory_has(inventory, item)
	if index != -1:
		all[inventory][index].amount += amount
	else:
		all[inventory].append(InventorySlot.new(item, amount))
	
func inventory_has(inventory: String, item: Object) -> int:
	for i in len(all[inventory]):
		if item.equals(all[inventory][i].object):
			return i
	return -1

func remove_from_inventory(inventory: String, item: Object) -> void:
	var index := inventory_has(inventory, item)
	if index != -1:
		all[inventory].remove_at(index)

func initialize_recipes():
	pass
	# for recipe in all["Recipes"]:
	# 	all["Recipe Inventory"].append(InventorySlot.new(recipe, 2))
func initialize_seed():
	all["Seed"] = RandomNumberGenerator.new()

