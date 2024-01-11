"""

Ingredient to recipe menu
This script just closes it at certain times

"""
extends Node

func _ready() -> void:
	SignalManager.connect("pot_done", close_menu)
	SignalManager.connect("escape_ingredient_to_recipe", close_menu)

func close_menu() -> void:
	queue_free()