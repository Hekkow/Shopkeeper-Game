extends Node
var money = 200

func _ready() -> void:
	SignalManager.connect("item_sold", on_item_sold)
	SignalManager.connect("shop_button_pressed", on_shop_button_pressed)

func on_shop_button_pressed(item):
	if money - item.price < 0:
		return
	money -= item.price
	SignalManager.emit_signal("bought_item", item)
	SignalManager.emit_signal("player_money_updated", money)

func on_item_sold(item: Item) -> void:
	money += item.sold_price
	SignalManager.emit_signal("player_money_updated", money)
