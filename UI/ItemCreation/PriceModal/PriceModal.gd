"""

Price setting pop-up, this script just deletes it when it receives certain signals

"""

extends CenterContainer

func _ready() -> void:
	SignalManager.connect("recipe_pressed", delete_this)
	SignalManager.connect("price_set", delete_this)
	SignalManager.connect("escape_recipe_to_item_price_modal", delete_this)
	SignalManager.connect("store_opened", delete_this)

func delete_this(_item=null):
	SignalManager.emit_signal("price_modal_despawned")
	queue_free()