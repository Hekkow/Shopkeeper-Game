"""

Shows error message on price input

"""

extends Label

func _ready():
	SignalManager.connect("invalid_price", on_invalid_price)
	
func on_invalid_price(message):
	text = message