extends Node

class_name Menu

var click_signal

@onready var grid_menu = $GridMenu

func _gui_input(event):
	if event is InputEventMouseButton && event.pressed:
		SignalManager.emit_signal(click_signal)