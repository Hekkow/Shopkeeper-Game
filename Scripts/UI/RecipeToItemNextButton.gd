extends Button

func _pressed() -> void:
	print("HERE2")
	SignalManager.emit_signal("store_opened")
