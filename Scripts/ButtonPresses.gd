extends Control

var usingIngredients = []

var progress_bars = []

func _ready():

	var ingredients = []
	ingredients.append(Ingredient.new("helo", [10, 30, 10]))
	ingredients.append(Ingredient.new("hola", [30, 10, 10]))
	ingredients.append(Ingredient.new("bonjourno", [10, 10, 30]))
	ingredients.append(Ingredient.new("a", [10, 0, 0]))
	ingredients.append(Ingredient.new("b", [0, 10, 0]))
	ingredients.append(Ingredient.new("c", [0, 0, 5]))
	ingredients.append(Ingredient.new("d", [5, 20, 40]))
	for i in range(Element.numberElements):
		var progress_bar = ProgressBar.new()
		add_child(progress_bar)
		progress_bar.set_size(Vector2(200, 20))
		progress_bar.set_position(Vector2(10, 300 + i * 30))
		progress_bar.value = 31
		progress_bars.append(progress_bar)
	for i in range(len(ingredients)):
		var button = Button.new()
		add_child(button)
		button.set_position(Vector2(100*i + 10*i + 10, 100))
		button.set_size(Vector2(100, 120))
		button.text = ingredients[i].ingredientName
		for element in range(len(ingredients[i].elements)):
			if ingredients[i].elements[element] != 0:
				button.text += "\n" + Element.elementNames[element] + ": " + str(ingredients[i].elements[element])
		button.pressed.connect(Callable(_on_button_pressed).bind(ingredients[i]))
	var resetButton = Button.new()
	add_child(resetButton)
	resetButton.set_position(Vector2(10, 10))
	resetButton.set_size(Vector2(100, 40))
	resetButton.text = "Reset"
	resetButton.pressed.connect(reset)

func _on_button_pressed(ingredient):
	usingIngredients.append(ingredient)
	var elements = Element.ingredients_to_element(usingIngredients)
	var percentages = Element.element_to_percentages(elements)
	for i in range(len(elements.elements)):
		progress_bars[i].value = percentages[i]
	print(get_node("RecipeChecker").check_recipes(elements))

func reset():
	usingIngredients = []