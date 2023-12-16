extends Node
class_name Ingredient
var ingredientName
var elements

func _init(_ingredientName, _elements):
	ingredientName = _ingredientName
	elements = _elements
	
func _to_string(): 
	return ingredientName + str(elements)
 