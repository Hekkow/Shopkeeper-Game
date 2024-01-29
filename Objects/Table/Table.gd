extends Node2D

class_name Table

@export var signal_name: String

var interactable = true

func interact():
	SignalManager.emit_signal(signal_name)