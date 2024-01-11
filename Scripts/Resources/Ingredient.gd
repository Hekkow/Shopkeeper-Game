extends Resource
class_name Ingredient
@export var ingredient_name: String
@export var element: Element

func _init(_ingredient_name: String = "", _elements: Element = Element.new()) -> void:
	ingredient_name = _ingredient_name
	element = _elements

func equals(_ingredient: Ingredient) -> bool:
	return ingredient_name == _ingredient.ingredient_name

func _to_string() -> String: 
	return ingredient_name + " " + str(element)
 
func to_str() -> String: 
	return "%s\nA: %s\nB: %s\nC: %s" % [ingredient_name, element.a, element.b, element.c]