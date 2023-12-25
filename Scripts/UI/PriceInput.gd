"""

Gets price and sends signal with a new item based on that price

"""

extends LineEdit

var recipe: Recipe

func _ready() -> void:
	SignalManager.connect("price_modal_spawned", set_recipe)
	text_submitted.connect(on_price_enter)
	grab_focus()

func set_recipe(_recipe: Recipe) -> void:
	recipe = _recipe

func on_price_enter(price: String) -> void:
	if price == "":
		SignalManager.emit_signal("price_set", Item.new(recipe, recipe.base_price))
	else:
		if price.is_valid_int():
			SignalManager.emit_signal("price_set", Item.new(recipe, int(price)))
		else:
			SignalManager.emit_signal("invalid_price", "Error: Not a number")
	
