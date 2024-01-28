extends Node

var list: Array
var inventory = Inventory.new()
var pot = Inventory.new()

func _ready():
	list = Helper.get_resources("Ingredients")
	for i in list:
		inventory.add(i, 30)
	SignalManager.connect("ingredient_added_to_pot", on_ingredient_added)
	SignalManager.connect("ingredients_reset", on_ingredients_reset)
	SignalManager.connect("recipe_made", on_recipe_made)
	SignalManager.connect("shop_button_pressed", on_shop_button_pressed)

func on_shop_button_pressed(ingredient):
	if not ingredient is Ingredient:
		return
	inventory.add(ingredient)


func on_ingredient_added(slot: InventorySlot):
	pot.add(slot.object)
	if (slot.subtract() == 0):
		inventory.remove(slot.object)
	SignalManager.emit_signal("ingredient_removed_from_inventory", slot)
	
func on_ingredients_reset() -> void:
	for i in range(len(pot.inv) - 1, -1, -1):
		var ingredient_slot = pot.inv[i]
		inventory.add(ingredient_slot.object, ingredient_slot.amount)
		pot.remove(ingredient_slot.object)

func add(ingredient, amount):
	for i in list:
		if ingredient == i.ingredient_name:
			inventory.add(i, amount)

func on_recipe_made(_recipe) -> void:
	pot.inv = []
	if len(inventory.inv) == 0:
		SignalManager.emit_signal("pot_done")