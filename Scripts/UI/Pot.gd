"""

Pot checks for whether any recipe is craftable, and if it is it shows a button to craft it

"""

extends Container

func _ready() -> void:
	SignalManager.connect("ingredient_added_to_pot", on_ingredient_added)
	SignalManager.connect("ingredients_reset", on_ingredients_reset)
	check_for_recipes()

func on_ingredient_added(_ingredients) -> void:
	if get_child_count() > 0:
		get_child(0).queue_free()
	check_for_recipes()

func check_for_recipes():
	var recipe = Recipes.check_recipes(Element.ingredients_to_element(Ingredients.pot.inv))
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
