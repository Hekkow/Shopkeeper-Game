extends Area2D
class_name Exit

@export var to: String
@export var spawn_point: Vector2
@export var enabled = true

func _enter_tree():
	get_tree().current_scene.exits.append(self)
	
func triggered():
	if !enabled:
		return
	SignalManager.emit_signal("change_scene", to)
