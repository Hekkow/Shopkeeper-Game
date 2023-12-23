extends Button


# Called when the node enters the scene tree for the first time.
func _ready():
	pressed.connect(reset)


func reset():
	SignalManager.emit_signal("ingredients_reset")