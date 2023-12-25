extends Control

func _ready() -> void:
	SignalManager.connect("store_opened", close_menu)
	SignalManager.connect("recipe_to_item_clicked", close_menu)
	SignalManager.connect("price_set", on_price_set)
	SignalManager.connect("item_placed", on_item_placed)
	
func on_price_set(_item):
	modulate.a = 0
	set_children_mouse_filter(Control.MOUSE_FILTER_IGNORE)
func on_item_placed(_item):
	modulate.a = 1
	set_children_mouse_filter(Control.MOUSE_FILTER_STOP)

func set_children_mouse_filter(value):
	mouse_filter = value
	for node in Helper.get_all_children(self):
		if "mouse_filter" in node:
			node.mouse_filter = value
		

func close_menu() -> void:
	queue_free()

