"""

Resets ingredients and pot when clicked

"""

extends Button

func _pressed() -> void:
	SignalManager.emit_signal("ingredients_reset")