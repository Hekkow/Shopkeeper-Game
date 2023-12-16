extends Container


var _progress_bars = []

func _ready():
	initialize_bars()
	SignalManager.connect("ingredient_added", _on_ingredient_added)
	SignalManager.connect("ingredients_reset", on_ingredients_reset)

func initialize_bars():
	for i in range(Element.numberElements):
		var progress_bar = ProgressBar.new()
		add_child(progress_bar)
		progress_bar.set_size(Vector2(200, 20))
		progress_bar.set_position(Vector2(10, 300 + i * 30))
		progress_bar.value = 0
		_progress_bars.append(progress_bar)

func _on_ingredient_added(_ingredients):
	var elements = Element.ingredients_to_element(Global.potIngredients)
	var percentages = Element.element_to_percentages(elements)
	for i in range(Element.numberElements):
		_progress_bars[i].value = percentages[i]

func on_ingredients_reset():
	for bar in _progress_bars:
		bar.value = 0
