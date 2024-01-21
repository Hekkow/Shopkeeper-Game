extends Area2D
class_name Door
@export var door_to: String
var interactable = true
func interact():
	SignalManager.emit_signal("scene_changed", door_to)
	get_tree().change_scene_to_file("res://Scenes/Levels/" + door_to + ".tscn")