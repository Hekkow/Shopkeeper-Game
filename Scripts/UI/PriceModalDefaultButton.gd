extends Button

var recipe: Recipe

func _ready() -> void:
	SignalManager.connect("price_modal_spawned", on_price_modal_spawned)
	grab_focus()

func on_price_modal_spawned(_recipe: Recipe) -> void:
	recipe = _recipe

func _pressed() -> void:
	Data.all["Store Items Before"].append([recipe, recipe.base_price])
	SignalManager.emit_signal("price_set")
