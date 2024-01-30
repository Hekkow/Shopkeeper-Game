extends CustomUI

@onready var grid_menu = $GridMenu

var pot = Inventory.new()
var pot_button
var pot_recipe

func _ready():
	grid_menu.load_items(Ingredients.inventory.inv, add_to_pot)

func add_to_pot(button, ingredient):
	pot.add(ingredient.object)
	SignalManager.emit_signal("ingredient_added_to_pot", ingredient.object)
	button.text = ingredient.to_str()
	check_pot()

func check_pot():
	pot_recipe = Recipes.check_recipes(pot)
	if pot_button != null:
		pot_button.queue_free()
	if pot_recipe != null:
		pot_button = Paths.grid_button.instantiate()
		add_child(pot_button)
		pot_button.text = str(pot_recipe)
		pot_button.pressed.connect(pot_pressed)

func pot_pressed():
	SignalManager.emit_signal("pot_pressed", pot_recipe)
	pot_button.queue_free()
	pot = Inventory.new()

func _exit_tree():
	SignalManager.emit_signal("craft_menu_closed", pot)