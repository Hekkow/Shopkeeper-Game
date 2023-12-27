extends Area2D

func _ready() -> void:
	SignalManager.connect("store_initialized", on_store_initialized)
	
func on_store_initialized():
	Data.store.door = self