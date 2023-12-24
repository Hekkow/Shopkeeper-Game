extends Panel


func _ready() -> void:
	self.connect("gui_input", Callable(self, "on_panel_clicked"))

func on_panel_clicked(event) -> void:
	if event is InputEventMouseButton and event.is_pressed():
		SignalManager.emit_signal("ingredient_to_recipe_panel_clicked")