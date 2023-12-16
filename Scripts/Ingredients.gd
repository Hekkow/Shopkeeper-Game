extends Container



func _ready():
	
	initialize_buttons()
	SignalManager.connect("ingredients_reset", on_ingredients_reset)
	SignalManager.connect("ingredient_added", on_ingredient_added)



func initialize_buttons():
	for i in range(len(InitItems.ingredients)):
		var button = Button.new()
		add_child(button)
		button.set_position(Vector2(100*i + 10*i + 10, 100))
		button.set_size(Vector2(100, 120))
		button.text = InitItems.ingredients[i].ingredientName
		for element in range(len(InitItems.ingredients[i].elements)):
			if InitItems.ingredients[i].elements[element] != 0:
				button.text += "\n" + Element.elementNames[element] + ": " + str(InitItems.ingredients[i].elements[element])
		button.pressed.connect(Callable(_on_button_pressed).bind(InitItems.ingredients[i]))

func _on_button_pressed(ingredient):
	Global.potIngredients.append(ingredient)
	SignalManager.emit_signal("ingredient_added", ingredient)

func on_ingredient_added(_ingredient):
	print(Recipe.check_recipes(Element.ingredients_to_element(Global.potIngredients)))

func on_ingredients_reset():
	Global.potIngredients = []
