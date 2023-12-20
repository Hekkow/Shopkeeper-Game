extends Container

func _ready():
	initialize_buttons()
	SignalManager.connect("ingredients_reset", on_ingredients_reset)

func initialize_buttons():
	var ingredients = Data.all["Ingredients"]
	for i in range(len(ingredients)):
		var button = Button.new()
		add_child(button)
		button.set_position(Vector2(Data.all["UI"]["itemButtonWidth"]*i + Data.all["UI"]["itemMargin"]*i + Data.all["UI"]["itemMargin"], Data.all["UI"]["itemMargin"]))
		button.set_size(Vector2(Data.all["UI"]["itemButtonWidth"], Data.all["UI"]["itemButtonHeight"]))
		button.text = ingredients[i].ingredientName
		for element in range(len(ingredients[i].elements)):
			if ingredients[i].elements[element] != 0:
				button.text += "\n" + Element.elementNames[element] + ": " + str(ingredients[i].elements[element])
		button.pressed.connect(Callable(_on_button_pressed).bind(ingredients[i]))

func _on_button_pressed(ingredient):
	Data.all["Pot Ingredients"].append(ingredient)
	SignalManager.emit_signal("ingredient_added", ingredient)

func on_ingredients_reset():
	Data.all["Pot Ingredients"] = []
