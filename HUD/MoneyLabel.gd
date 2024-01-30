extends Label

func _ready():
	update_money()
	SignalManager.connect("bought_item", update_money)
	SignalManager.connect("item_sold", update_money)
	

func update_money(_thing=null):
	text = "$" + str(PlayerStats.money)