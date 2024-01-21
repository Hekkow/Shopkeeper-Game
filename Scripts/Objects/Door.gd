extends Area2D
class_name Door
@export var door_to: String
var interactable = true
func interact():
	SignalManager.emit_signal("change_scene", door_to)