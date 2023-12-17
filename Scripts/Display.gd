extends Container

func _ready():
	SignalManager.connect("price_set", _on_price_set)

func _on_price_set(item):
	Data.all["Store Items"].append(item)
	var itemButton = Button.new()
	add_child(itemButton)
	var i = get_child_count() - 1
	itemButton.set_position(Vector2(Data.all["UI"]["itemButtonWidth"]*i + Data.all["UI"]["itemMargin"]*i + Data.all["UI"]["itemMargin"], Data.all["UI"]["itemMargin"]))
	itemButton.set_size(Vector2(Data.all["UI"]["itemButtonWidth"], Data.all["UI"]["itemButtonHeight"]))
	itemButton.text = item.to_string()
	itemButton.set_meta("Item", item)
	itemButton.pressed.connect(Callable(_on_item_pressed).bind(item))

func _on_item_pressed(item):
	item.sold_price = item.price
	SignalManager.emit_signal("item_sold", item)
	Helper.find_by_metadata(self, "Item", item).queue_free()
