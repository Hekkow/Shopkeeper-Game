extends Menu

func _ready():
	click_signal = "ingredient_store_panel_pressed"
	grid_menu.load_items(Stores.ingredients, buy_item, true)


func buy_item(_button, item):
	SignalManager.emit_signal("attempted_buy", item)
