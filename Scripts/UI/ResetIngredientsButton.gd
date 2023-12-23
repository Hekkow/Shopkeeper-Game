extends Button

func _ready() -> void:
	pressed.connect(reset)


func reset() -> void:
	SignalManager.emit_signal("ingredients_reset")