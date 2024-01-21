extends Area2D

@export var exit_to: String

func _ready():
	body_entered.connect(on_stepped_on)

func on_stepped_on(body):
	if body is Player:
		SignalManager.emit_signal("scene_changed", exit_to)
		get_tree().call_deferred("change_scene_to_file", "res://Scenes/Levels/" + exit_to + ".tscn")