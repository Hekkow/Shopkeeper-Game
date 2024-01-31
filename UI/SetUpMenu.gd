extends Menu

func _ready():
	click_signal = "set_up_menu_panel_pressed"
	grid_menu.load_items(Recipes.inventory.inv, create_item)

func create_item(_button, recipe):
	SignalManager.emit_signal("item_created", Item.new(recipe.object))

