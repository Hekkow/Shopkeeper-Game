extends Container

func _ready():
	initialize_buttons()
	SignalManager.connect("price_set", _on_price_set)

func initialize_buttons():
	var items = Data.all["Items"]
	for i in len(items):
		var item = Button.new()
		add_child(item)
		item.set_position(Vector2(Data.all["UI"]["itemButtonWidth"]*i + Data.all["UI"]["itemMargin"]*i + Data.all["UI"]["itemMargin"], Data.all["UI"]["itemMargin"]))
		item.set_size(Vector2(Data.all["UI"]["itemButtonWidth"], Data.all["UI"]["itemButtonHeight"]))
		item.text = items[i].to_string()
		item.set_meta("Item", items[i])
		item.pressed.connect(Callable(_on_item_pressed).bind(items[i]))

func _on_item_pressed(item):
	SignalManager.emit_signal("item_added", item)

func _on_price_set(item):
	Helper.find_by_metadata(self, "Item", item).queue_free()
