extends CenterContainer

func _ready() -> void:
	SignalManager.connect("price_set", on_price_set)

func on_price_set() -> void:
	queue_free()
