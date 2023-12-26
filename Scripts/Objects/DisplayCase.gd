extends Area2D

var pos
var size
var item

func _ready():
	SignalManager.connect("store_initialized", on_store_initialized)
	SignalManager.connect("item_placed", on_item_placed)
	SignalManager.connect("item_sold", on_item_sold)
	SignalManager.connect("item_picked_up", on_item_picked_up)

func on_item_placed(case, _item):
	if case != self:
		return
	item = _item

func on_item_sold(_item):
	if item != item:
		return
	item = null

func on_item_picked_up(case, _item):
	if case != self:
		return
	item = null

func on_store_initialized():
	Data.store.display_cases.append(self)
	size = get_node("CollisionShape2D").shape.size
	pos = Vector2(position.x + size.x / 2, position.y + size.y / 2)
	