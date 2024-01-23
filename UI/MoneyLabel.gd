"""

Shows player's money

"""

extends Label

func _ready() -> void:
	SignalManager.connect("player_money_updated", on_player_money_updated)
	text = "$" + str(PlayerStats.money)

func on_player_money_updated(money: int) -> void:
	text = "$" + str(money)