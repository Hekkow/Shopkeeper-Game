extends Control

class_name BaseGridMenu

@onready var grid = get_node("MarginContainer/ScrollContainer/GridContainer")

func load_items(script: Script, arr, button_path):
	for item in arr:
		var button = button_path.instantiate()
		button.set_script(script)
		button.set_variables(item)
		grid.add_child(button)

func remove_items():
	Helper.remove_children(grid)