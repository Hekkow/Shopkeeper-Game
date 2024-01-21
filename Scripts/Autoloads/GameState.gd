extends Node

enum State {
	Store,
	World
}

@export var state = State.Store

func _ready():
	SignalManager.connect("scene_changed", on_scene_changed)

func on_scene_changed(to):
	var previous_state = state
	match to:
		"World":
			state = State.World
		"Store":
			state = State.Store
	SignalManager.emit_signal("state_switched", previous_state, state)