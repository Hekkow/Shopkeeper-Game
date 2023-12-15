extends Node

var recipes = []
var maximum = 10000
func _ready():
	recipes.append(Recipe.new("Healing", Element.new([1, 1, 1])))
	recipes.append(Recipe.new("evil", Element.new([2, 2, 1])))

func check_recipes(elements):
	var minimum = maximum
	var values = []
	for i in range(len(elements.elements)):
		var amount = elements.elements[i]
		if amount < minimum and amount != 0:
			minimum = amount
	for i in range(len(elements.elements)):
		values.append(float(elements.elements[i])/float(minimum))
	for recipe in recipes:
		if recipe.equals(values):
			return recipe
