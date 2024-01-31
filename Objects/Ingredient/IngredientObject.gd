extends Node2D

var ingredient: Ingredient
var pos
var interactable = true
func interact():
	SignalManager.emit_signal("ingredient_picked_up", ingredient, pos)
	queue_free()

func set_variables(_ingredient, _pos):
	ingredient = _ingredient
	pos = _pos