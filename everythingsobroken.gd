extends Control



var mouse_clicked = false

var dragging = false

var mouse_held_start = -1

func _process(delta):
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		print(str(Time.get_ticks_msec()) + " " + str(mouse_held_start) + " = " + str(Time.get_ticks_msec() - mouse_held_start))
		if Time.get_ticks_msec() - mouse_held_start >= 1000:
			print("working")

func _gui_input(event):
	if event is InputEventMouseButton:
		if event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
			if mouse_clicked:
				mouse_held_start = Time.get_ticks_msec()
				mouse_clicked = false
				dragging = true
		elif event.button_index == MOUSE_BUTTON_LEFT and not event.pressed:
			if dragging:
				mouse_held_start = -1
				dragging = false
			mouse_clicked = true
		if event.pressed and event.button_index == MOUSE_BUTTON_RIGHT:
			mouse_clicked = false
