extends Node

class_name Inventory

var inv = []

func has(item: Object) -> int:
	for i in len(inv):
		if item.equals(inv[i].object):
			return i
	return -1

func add(item: Object, amount: int = 1) -> void:
	var index := has(item)
	if index != -1:
		inv[index].amount += amount
	else:
		inv.append(InventorySlot.new(item, amount))

func remove(item: Object) -> void:
	var index := has(item)
	if index != -1:
		inv.remove_at(index)

func _to_string():
	return str(inv)