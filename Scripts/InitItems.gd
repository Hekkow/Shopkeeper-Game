extends Node

static var ingredients = []
static var recipes = []

func _ready():
	initialize_ingredients()
	initialize_recipes()

func initialize_ingredients():
	ingredients.append(Ingredient.new("helo", [10, 30, 10]))
	ingredients.append(Ingredient.new("hola", [30, 10, 10]))
	ingredients.append(Ingredient.new("bonjourno", [10, 10, 30]))
	ingredients.append(Ingredient.new("a", [10, 0, 0]))
	ingredients.append(Ingredient.new("b", [0, 10, 0]))
	ingredients.append(Ingredient.new("c", [0, 0, 5]))
	ingredients.append(Ingredient.new("d", [5, 20, 40]))

func initialize_recipes():
	recipes.append(Recipe.new("Healing", Element.new([1, 1, 1])))
	recipes.append(Recipe.new("evil", Element.new([2, 2, 1])))