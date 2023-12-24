extends Control

func _ready() -> void:
	SignalManager.connect("store_opened", close_menu)
	SignalManager.connect("recipe_to_item_clicked", close_menu)

func close_menu() -> void:
	queue_free()
