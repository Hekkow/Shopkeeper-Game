extends Container

func _ready():
	SignalManager.connect("ingredient_added", _on_ingredient_added)
	SignalManager.connect("ingredients_reset", _on_ingredients_reset)

func _on_ingredient_added(_ingredients):
	if get_child_count() > 0:
		get_child(0).queue_free()
	var pot = Button.new()
	var recipe = Recipe.check_recipes(Element.ingredients_to_element(Data.all["Pot Ingredients"]))
	if !recipe:
		return
	add_child(pot)
	pot.set_position(Vector2(0, 0))
	pot.set_size(Vector2(100, 120))
	pot.text = recipe.recipeName
func _on_ingredients_reset():
	if get_child_count() > 0:
		remove_child(get_child(0))