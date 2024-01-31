extends Menu

@onready var pot_container = $PotContainer

var pot = Inventory.new()
var pot_button
var pot_recipe
@onready var ratio_bars = get_node("RatioBars").get_children()

func _ready():
	click_signal = "craft_menu_panel_pressed"
	grid_menu.load_items(Ingredients.inventory.inv, add_to_pot)

func add_to_pot(button, ingredient):
	pot.add(ingredient.object)
	SignalManager.emit_signal("ingredient_added_to_pot", ingredient.object)
	button.text = ingredient.to_str()
	check_pot()

func check_pot():
	var element = Element.inventory_to_element(pot)
	pot_recipe = Recipes.check_recipes(element)
	set_ratio_bars(element)
	if pot_button != null:
		pot_button.queue_free()
	if pot_recipe != null:
		create_pot()
		
func set_ratio_bars(element: Element):
	var percentages = element.element_to_percentages()
	for i in len(percentages):
		ratio_bars[i].value = percentages[i]

func create_pot():
	pot_button = Paths.grid_button.instantiate()
	pot_container.add_child(pot_button)
	pot_button.text = str(pot_recipe)
	pot_button.pressed.connect(pot_pressed)

func pot_pressed():
	SignalManager.emit_signal("pot_pressed", pot_recipe)
	pot_button.queue_free()
	pot = Inventory.new()
	set_ratio_bars(Element.new())

func _exit_tree():
	SignalManager.emit_signal("craft_menu_closed", pot)