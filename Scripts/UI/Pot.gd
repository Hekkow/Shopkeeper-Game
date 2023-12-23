extends Container

func _ready() -> void:
	SignalManager.connect("ingredient_added", on_ingredient_added)
	SignalManager.connect("ingredients_reset", on_ingredients_reset)

func on_ingredient_added(_ingredients) -> void:
	if get_child_count() > 0:
		get_child(0).queue_free()
	var recipe = Recipe.check_recipes(Element.ingredients_to_element(Data.all["Pot Ingredients"]))
	if !recipe:
		return
	var pot = Button.new()
	add_child(pot)
	pot.set_position(Vector2(0, 0))
	pot.set_size(Vector2(100, 120))
	pot.text = recipe.recipe_name
	pot.pressed.connect(Callable(on_pot_clicked).bind(pot, recipe))

func on_pot_clicked(pot: Node, recipe: Recipe) -> void:
	Data.add_to_inventory("Recipe Inventory", recipe)
	Data.all["Pot Ingredients"] = []
	pot.queue_free()
	SignalManager.emit_signal("recipe_made")
	SignalManager.emit_signal("ingredients_reset")

func on_ingredients_reset() -> void:
	if get_child_count() > 0:
		remove_child(get_child(0))
