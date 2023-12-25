extends Button

func _pressed() -> void:
	SignalManager.emit_signal("store_opened")
