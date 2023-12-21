extends Node

@export var money: int

func _ready():
	SignalManager.connect("item_sold", on_item_sold)

func on_item_sold(item):
	money += item.sold_price
	SignalManager.emit_signal("player_money_updated", money)
