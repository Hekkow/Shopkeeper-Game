extends Resource
class_name Ingredient
@export var ingredient_name: String
@export var element: Element

func _init(_ingredient_name="", _elements=Element.new()):
	ingredient_name = _ingredient_name
	element = _elements

func equals(_ingredient):
	return ingredient_name == _ingredient.ingredient_name

func _to_string(): 
	return ingredient_name + "\n" + str(element)
 
