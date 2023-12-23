extends Button


func _pressed() -> void:
	SignalManager.emit_signal("pot_done")
