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
	var scene := load("res://Scenes/UI/ItemDisplayButton.tscn")
	var button = scene.instantiate()
	button.set_script(PotButton)
	button.recipe = recipe
	add_child(button)

func on_ingredients_reset() -> void:
	if get_child_count() > 0:
		remove_child(get_child(0))
