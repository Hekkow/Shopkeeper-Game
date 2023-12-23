extends Node

var all = {
	"UI" = {
		"itemButtonWidth" = 140,
		"itemButtonHeight" = 120,
		"itemMargin" = 20,
		"textInputWidth" = 100,
		"textInputHeight" = 40,
	},
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
	"Item ID" = 0
}
func _ready():
	all["Recipes"] = Helper.get_resources("Recipes")
	all["Characters"] = Helper.get_resources("Characters")
	all["Ingredients"] = Helper.get_resources("Ingredients")
	initialize_recipes()
	initialize_ingredient_inventory()
	initialize_seed()

func initialize_ingredient_inventory():
	for i in all["Ingredients"]:
		add_to_inventory("Ingredient Inventory", i, 10)

func add_to_inventory(inventory, item, amount=1):
	var index = inventory_has(inventory, item)
	if index != -1:
		all[inventory][index].amount += amount
	else:
		all[inventory].append(InventorySlot.new(item, amount))
	
func inventory_has(inventory, item):
	for i in len(all[inventory]):
		if item.equals(all[inventory][i].object):
			return i
	return -1

func remove_from_inventory(inventory, item):
	var index = inventory_has(inventory, item)
	if index != -1:
		all[inventory].remove_at(index)

func initialize_recipes():
	pass
	# for recipe in all["Recipes"]:
	# 	all["Recipe Inventory"].append(InventorySlot.new(recipe, 2))
func initialize_seed():
	all["Seed"] = RandomNumberGenerator.new()

