extends Container

func _ready():
	SignalManager.connect("item_sold", on_item_sold)
	var customers = Data.all["Customers"]
	for i in range(len(customers)):
		var button = Button.new()
		add_child(button)
		button.set_position(Vector2(Data.all["UI"]["itemButtonWidth"]*i + Data.all["UI"]["itemMargin"]*i + Data.all["UI"]["itemMargin"], Data.all["UI"]["itemMargin"]))
		button.set_size(Vector2(Data.all["UI"]["itemButtonWidth"], Data.all["UI"]["itemButtonHeight"]))
		button.text = customers[i].to_string()
		button.pressed.connect(Callable(_on_button_pressed).bind(customers[i]))
		button.set_meta("customer", customers[i])

func on_item_sold(customer, _item):
	for child in get_children():
		if child.get_meta("customer") == customer:
			child.text = customer.to_string()

func _on_button_pressed(customer):
	Data.all["Active Customer"] = customer