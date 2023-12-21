extends Container


var _progress_bars = []
var _labels = []

func _ready():
	initialize_bars()
	initialize_labels()
	SignalManager.connect("ingredient_added", _on_ingredient_added)
	SignalManager.connect("ingredients_reset", on_ingredients_reset)

func initialize_bars():
	for i in range(Element.numberElements):
		var progress_bar = ProgressBar.new()
		add_child(progress_bar)
		progress_bar.set_size(Vector2(200, 20))
		progress_bar.set_position(Vector2(10, 300 + i * 30))
		progress_bar.show_percentage = false
		_progress_bars.append(progress_bar)

func initialize_labels():
	for i in range(Element.numberElements):
		var label = Label.new()
		_progress_bars[i].add_child(label)
		recenter_label(label, 0)
		_labels.append(label)

func _on_ingredient_added(_ingredients):
	var elements = Element.ingredients_to_element(Data.all["Pot Ingredients"])
	var percentages = elements.element_to_percentages()
	for i in range(Element.numberElements):
		_progress_bars[i].value = percentages[i]
		recenter_label(_labels[i], elements.arr()[i])

func recenter_label(label, value): # doesnt even work man
	label.text = str(value)
	label.set_position(Vector2(_progress_bars[0].get_size().x / 2 - label.get_minimum_size().x / 2, 0))

func on_ingredients_reset():
	for i in len(_progress_bars):
		_progress_bars[i].value = 0
		_labels[i].text = "0"
	
