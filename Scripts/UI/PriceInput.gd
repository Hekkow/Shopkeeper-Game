extends LineEdit

var recipe: Recipe

func _ready() -> void:
	SignalManager.connect("price_modal_spawned", on_price_modal_spawned)
	text_submitted.connect(on_price_enter)

func on_price_modal_spawned(_recipe: Recipe) -> void:
	recipe = _recipe

func on_price_enter(price: String) -> void:
	SignalManager.emit_signal("price_set", Item.new(recipe, int(price)))
	
