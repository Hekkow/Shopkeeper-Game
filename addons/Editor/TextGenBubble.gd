@tool
extends Control

signal bubble_removed
signal bubble_clicked
signal dragging_started
signal dragging_ended

var mouse_clicked = false


var mouse_held_start = -1

var dragging = false

func _process(delta):
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		if Time.get_ticks_msec() - mouse_held_start >= 70 && mouse_held_start != -1:
			mouse_held_start = -1
			emit_signal("dragging_started", self, get_local_mouse_position())

func _gui_input(event):
	if event is InputEventMouseButton:
		if event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
				emit_signal("bubble_clicked", self, get_local_mouse_position())
				mouse_held_start = Time.get_ticks_msec()
		elif event.button_index == MOUSE_BUTTON_LEFT and not event.pressed:
			mouse_held_start = -1
			emit_signal("dragging_ended")
		if event.pressed and event.button_index == MOUSE_BUTTON_RIGHT:
			emit_signal("bubble_removed", self)

