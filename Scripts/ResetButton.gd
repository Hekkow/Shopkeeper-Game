extends Container

func _ready():
	initialize_reset()

func initialize_reset():
	var resetButton = Button.new()
	add_child(resetButton)
	resetButton.set_position(Vector2(10, 10))
	resetButton.set_size(Vector2(100, 40))
	resetButton.text = "Reset"
	resetButton.pressed.connect(reset)

func reset():
	SignalManager.emit_signal("ingredients_reset")
	
