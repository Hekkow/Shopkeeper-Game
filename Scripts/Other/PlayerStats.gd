extends Node
var money = 0

func _ready() -> void:
	SignalManager.connect("item_sold", on_item_sold)

func on_item_sold(item: Item) -> void:
	money += item.sold_price
	SignalManager.emit_signal("player_money_updated", money)
