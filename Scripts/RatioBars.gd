extends Container

var bars = []
var labels = []

func _ready():
	SignalManager.connect("ingredient_added", on_ingredient_added)
	SignalManager.connect("ingredients_reset", on_ingredients_reset)
	initialize_bars_and_labels()

func initialize_bars_and_labels():
	for item in get_children():
		bars.append(item.get_node("ProgressBar"))
		labels.append(item.get_node("Label"))

func on_ingredient_added(_ingredients):
	var elements = Element.ingredients_to_element(Data.all["Pot Ingredients"])
	var percentages = elements.element_to_percentages()
	for i in len(bars):
		bars[i].value = percentages[i]
		labels[i].text = str(elements.arr()[i])

func on_ingredients_reset():
	for i in len(bars):
		bars[i].value = 0
		labels[i].text = "0"
	
