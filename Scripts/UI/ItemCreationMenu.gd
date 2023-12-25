"""

Recipe to item menu
This script just sets the visibility of the menu depending on the stage of the game

"""

extends Control

func _ready() -> void:
	SignalManager.connect("store_opened", close_menu)
	SignalManager.connect("escape_recipe_to_item", close_menu)
	SignalManager.connect("price_set", is_no_visible)
	SignalManager.connect("item_placed", is_yes_visible)
	SignalManager.connect("item_placement_cancelled", is_yes_visible)

#- visible and is_visible both taken

func is_no_visible(_item):
	modulate.a = 0
func is_yes_visible(_item):
	modulate.a = 1
func close_menu() -> void:
	queue_free()
