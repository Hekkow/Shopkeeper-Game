extends Node

var previous_scene = "World"
var scene
@export var state = Scene.RandomStore
enum Scene {
	Store,
	World,
	RandomStore,
}

func _ready():
	match get_tree().current_scene.name: #- TEMP, JUST FOR TESTING
		"World":
			state = Scene.World
			previous_scene = "Store"
		"Store":
			state = Scene.Store
			previous_scene = "World"
		"RandomStore":
			state = Scene.RandomStore
			previous_scene = "World"
	SignalManager.connect("exit_triggered", change_scene)

func change_scene(scene_name):
	previous_scene = get_tree().current_scene.name
	match scene_name:
		"World":
			state = Scene.World
		"Store":
			state = Scene.Store
		"RandomStore":
			state = Scene.RandomStore
	SignalManager.emit_signal("scene_changing", scene)
	get_tree().call_deferred("change_scene_to_file", Paths.levels + scene_name + ".tscn")