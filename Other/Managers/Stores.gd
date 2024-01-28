extends Node

var ingredients = []

func _ready():
	for i in Ingredients.list:
		ingredients.append(i)