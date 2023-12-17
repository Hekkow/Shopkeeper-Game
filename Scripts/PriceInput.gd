extends Container

var priceInput

func _ready():
	SignalManager.connect("item_added", _on_item_added)

func _on_item_added(item):
	priceInput = LineEdit.new()
	add_child(priceInput)
	priceInput.grab_focus()
	priceInput.set_size(Vector2(Data.all["UI"]["textInputWidth"], Data.all["UI"]["textInputHeight"]))
	priceInput.text_submitted.connect(_on_price_enter.bind(item))
	

func _on_price_enter(text, item):
	priceInput.queue_free()
	item.price = int(text)
	SignalManager.emit_signal("price_set", item)