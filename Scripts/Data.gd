extends Node

var all = {
	"UI" = {
		"itemButtonWidth" = 140,
		"itemButtonHeight" = 120,
		"itemMargin" = 20,
		"textInputWidth" = 100,
		"textInputHeight" = 40,
	},
	"Player" = {
		"money" = 0
	},
	"Ingredients" = [
		Ingredient.new("helo", [10, 30, 10]),
		Ingredient.new("hola", [30, 10, 10]),
		Ingredient.new("bonjourno", [10, 10, 30]),
		Ingredient.new("a", [10, 0, 0]),
		Ingredient.new("b", [0, 10, 0]),
		Ingredient.new("c", [0, 0, 5]),
		Ingredient.new("d", [5, 20, 40]),
	],
	"Recipes" = [],
	# "Recipes" = [
	# 	Recipe.new("Healing", Element.new([1, 1, 1])),
	# 	Recipe.new("evil", Element.new([2, 2, 1])),
	# 	Recipe.new("flyer", Element.new([5, 2, 1])),
	# 	Recipe.new("litty chair", Element.new([1, 3, 1])),
	# 	Recipe.new("sam i am", Element.new([1, 3, 3])),
	# ],
	"Characters" = [],
	"Pot Ingredients" = [],
	"Store Items" = [],
	"Max Richness" = 5,
	"Max Friendship" = 5,
	"Item ID" = 0
}
func _ready():
	all["Recipes"] = Helper.get_resources("Recipes")
	all["Characters"] = Helper.get_resources("Characters")
	initialize_items()
	initialize_seed()
	
	


	# Helper.get_file_names(path)

func initialize_items():
	# all["Items"] = [
	# 	Item.new(10, all["Recipes"][0]),
	# 	Item.new(15, all["Recipes"][1]),
	# 	Item.new(20, all["Recipes"][2]),
	# 	Item.new(3, all["Recipes"][3]),
	# 	Item.new(27, all["Recipes"][4]),
	# ]
	pass
func initialize_seed():
	all["Seed"] = RandomNumberGenerator.new()

