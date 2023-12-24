extends Panel


func _ready() -> void:
	print("READY")
	self.connect("gui_input", Callable(self, "on_panel_clicked"))

func on_panel_clicked(event) -> void:
	if event is InputEventMouseButton and event.is_pressed():
		print("HERE")
		SignalManager.emit_signal("recipe_to_item_clicked")