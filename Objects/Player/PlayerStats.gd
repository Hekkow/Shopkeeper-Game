extends Node
var money = 200

func _ready() -> void:
	SignalManager.connect("item_sold", on_item_sold)
	SignalManager.connect("attempted_buy", on_attempted_buy)

func on_attempted_buy(item):
	if money - item.price < 0:
		return
	money -= item.price
	SignalManager.emit_signal("bought_item", item)

func on_item_sold(item: Item) -> void:
	money += item.sold_price
