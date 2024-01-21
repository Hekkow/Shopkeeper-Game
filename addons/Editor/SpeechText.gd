extends TextEdit

signal enter_pressed

func _gui_input(event):
	if event is InputEventKey and event.is_pressed():
		if event.scancode == KEY_ENTER:
			emit_signal("enter_pressed")