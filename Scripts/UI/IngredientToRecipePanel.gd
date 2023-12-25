"""

Ingredient to recipe background panel
Closes the ingredient to recipe menu when clicked

"""

extends Panel


func _ready() -> void:
	self.connect("gui_input", Callable(self, "on_panel_clicked"))

func on_panel_clicked(event) -> void:
	if event is InputEventMouseButton and event.is_pressed():
		SignalManager.emit_signal("escape_ingredient_to_recipe")

func _input(event):
	if event.is_action_pressed("ui_cancel"):
		SignalManager.emit_signal("escape_ingredient_to_recipe")