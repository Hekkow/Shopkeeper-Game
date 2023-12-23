extends Node

func _ready() -> void:
	SignalManager.connect("pot_done", close_menu)

func close_menu() -> void:
	queue_free()