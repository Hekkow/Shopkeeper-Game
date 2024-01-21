extends Node

var previous_scene = "Store"
var current_scene

func _ready():
	SignalManager.connect("change_scene", change_scene)

func change_scene(scene):
	previous_scene = current_scene
	current_scene = scene
	SignalManager.emit_signal("scene_changing", current_scene)
	get_tree().call_deferred("change_scene_to_file", "res://Scenes/Levels/" + current_scene + ".tscn")
	SignalManager.emit_signal("scene_changed", current_scene)