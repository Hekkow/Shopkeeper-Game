@tool
extends Button


@export var panel: Control

func _pressed():
	panel.save_file()