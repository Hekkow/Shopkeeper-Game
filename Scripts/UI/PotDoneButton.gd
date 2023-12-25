"""

Goes to recipe to item menu

"""

extends Button

func _pressed() -> void:
	SignalManager.emit_signal("pot_done")
