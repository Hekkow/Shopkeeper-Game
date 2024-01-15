extends Node

enum State {
	Haggling,
	Shopping,
	World
}
var state = State.World
func _ready():
	SignalManager.connect("haggling_started", on_haggling_started)
	SignalManager.connect("haggling_ended", on_haggling_ended)

func on_haggling_started(_customer):
	state = State.Haggling
func on_haggling_ended(_customer, _score_multiplier):
	state = State.Shopping
	SignalManager.emit_signal("haggling_done")