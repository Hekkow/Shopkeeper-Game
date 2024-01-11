@tool
extends Control

signal bubble_removed
signal bubble_clicked
signal dragging_started
signal dragging_ended
signal text_changed

var mouse_clicked = true


var mouse_held_start = -1

var dragging = false

func _ready():
	get_node("MarginContainer/VBoxContainer/LineEdit").text_submitted.connect(on_text_changed)
	get_node("MarginContainer/VBoxContainer/TextEdit").text_changed.connect(on_text_changed)

func on_text_changed(_text=null):
	emit_signal("text_changed")

func _process(delta):
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		if Time.get_ticks_msec() - mouse_held_start >= 70 && mouse_held_start != -1:
			mouse_held_start = -1
			emit_signal("dragging_started", self, get_local_mouse_position())

func _gui_input(event):
	if event is InputEventMouseButton:
		if event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
			if !mouse_clicked:
				emit_signal("bubble_clicked", self, get_local_mouse_position())
				mouse_held_start = Time.get_ticks_msec()
				mouse_clicked = true
		elif event.button_index == MOUSE_BUTTON_LEFT and not event.pressed:
			mouse_clicked = false
			mouse_held_start = -1
			emit_signal("dragging_ended")
		if event.pressed and event.button_index == MOUSE_BUTTON_RIGHT:
			emit_signal("bubble_removed", self)

