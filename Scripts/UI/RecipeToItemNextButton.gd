"""

Button inside recipe to item menu, opens store

"""

extends Button

func _pressed() -> void:
	SignalManager.emit_signal("store_opened")
