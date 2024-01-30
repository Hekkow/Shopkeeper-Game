extends Panel

@onready var grid_menu = $GridMenu

func _ready():
	grid_menu.load_items(Stores.ingredients, buy_item, true)


func buy_item(_button, item):
	SignalManager.emit_signal("attempted_buy", item)
