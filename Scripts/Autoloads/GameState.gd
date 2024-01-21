extends Node

enum State {
	Shopping,
	World
}
var state = State.World
func _ready():
	SignalManager.connect("scene_changed", on_scene_changed)

func on_scene_changed(to):
	match to:
		"World":
			state = State.World
		"Shopping":
			state = State.Shopping