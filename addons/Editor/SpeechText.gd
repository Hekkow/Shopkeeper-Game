extends TextEdit

signal enter_pressed

func _gui_input(event):
	print("HERERE")
	if event is InputEventKey and event.is_pressed():
		if event.scancode == KEY_ENTER:
			print("ERJOAEGJAEG")
			emit_signal("enter_pressed")