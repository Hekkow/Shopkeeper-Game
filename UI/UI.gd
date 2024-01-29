extends CanvasLayer

var stack = []

func _ready() -> void:
	pass
	
func instantiate_scene(scene):
	var scene_instance = scene.instantiate()
	add_child(scene_instance)
	stack.append(scene_instance)

func close():
	stack.pop_back().queue_free()

func _input(event):
	if event.is_action_pressed("ui_cancel"):
		if len(stack) > 0:
			stack.pop_back().queue_free()