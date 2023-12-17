extends Label

func _ready():
	SignalManager.connect("item_sold", on_item_sold)
	text = "$" + str(Data.all["Player"]["money"])

func on_item_sold(item):
	Data.all["Player"]["money"] += item.price
	text = "$" + str(Data.all["Player"]["money"])
