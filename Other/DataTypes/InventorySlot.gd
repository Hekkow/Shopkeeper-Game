extends Resource
class_name InventorySlot
var object
var amount

func _init(_object: Object =null, _amount: int =1) -> void:
	object = _object
	amount = _amount

func subtract() -> int:
	if amount > 0:
		amount -= 1
		return amount
	return -1

func _to_string() -> String:
	return "%s (%s)" % [object, amount]

func to_str() -> String:
	return "%s\n(%s)" % [object.to_str(), amount]

func button_str() -> String:
	return "%s\n(%s)" % [object.button_str(), amount]
