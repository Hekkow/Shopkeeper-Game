extends Node
class_name InventorySlot
var object
var amount

func _init(_object=null, _amount=1):
	object = _object
	amount = _amount

func subtract():
	if amount > 0:
		amount -= 1
		return amount
	return -1

func _to_string():
	return "%s (%s)" % [object, amount]