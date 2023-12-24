extends Panel


func _ready() -> void:
	self.connect("gui_input", Callable(self, "on_panel_clicked"))
	SignalManager.connect("price_set", on_price_set)
	SignalManager.connect("item_placed", on_item_placed)

func on_panel_clicked(event) -> void:
	if event is InputEventMouseButton and event.is_pressed():
		SignalManager.emit_signal("recipe_to_item_clicked")

func on_price_set(_item):
	modulate.a = 0
	mouse_filter = Control.MOUSE_FILTER_IGNORE
func on_item_placed(_item):
	print("HERE")
	modulate.a = 1
	mouse_filter = Control.MOUSE_FILTER_STOP
