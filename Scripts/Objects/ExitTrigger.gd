extends Area2D

@export var exit_to: String

func _ready():
	body_entered.connect(on_stepped_on)

func on_stepped_on(body):
	if body is Player:
		SignalManager.emit_signal("change_scene", exit_to)
		