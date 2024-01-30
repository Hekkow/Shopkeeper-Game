extends CustomUI

@onready var craft = $Craft
@onready var set_up = $SetUp

func _ready():
	craft.pressed.connect(on_craft_pressed)
	set_up.pressed.connect(on_set_up_pressed)
func on_craft_pressed():
	SignalManager.emit_signal("craft_button_pressed")
func on_set_up_pressed():
	SignalManager.emit_signal("set_up_button_pressed")
