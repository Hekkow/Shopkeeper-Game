extends Control

class_name BaseGridMenu

@onready var grid = get_node("MarginContainer/ScrollContainer/GridContainer")

func load_items(arr, on_click_function=null, store=false):
	for item in arr:
		var button = Paths.grid_button.instantiate()
		if on_click_function:
			button.pressed.connect(Callable(on_click_function).bind(button, item))
		if store:
			button.text = item.button_str() + "\n$" + str(item.price)
		else:
			button.text = item.button_str()
		grid.add_child(button)


# func load_items(script: Script, arr, on_click_function=null):
# 	for item in arr:
# 		var button = Paths.grid_button.instantiate()
# 		button.set_script(script)
# 		button.set_variables(item)
# 		if on_click_function:
# 			button.pressed.connect(Callable(on_click_function).bind(button))
# 		grid.add_child(button)


func remove_items():
	Helper.remove_children(grid)
