extends Label

func _ready():
	SignalManager.connect("player_money_updated", on_player_money_updated)
	text = "$" + str(Data.all["Player"]["money"])

func on_player_money_updated(money):
	text = "$" + str(money)
