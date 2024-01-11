"""

When pressed it creates a new item with the recipe's base price and sends that in a signal

"""

extends Button

var recipe: Recipe

func _ready() -> void:
	SignalManager.connect("price_modal_spawned", set_recipe)
	SignalManager.connect("recipe_pressed", set_recipe)

func set_recipe(_recipe: Recipe) -> void:
	recipe = _recipe

func _pressed() -> void:
	SignalManager.emit_signal("price_set", Item.new(recipe, recipe.base_price))
