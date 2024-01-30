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

func add_inventory(inventory: Inventory):
	for slot in inventory.inv:
		add(slot.object, slot.amount)

func remove(item: Object, amount: int = -1) -> void:
	var index := has(item)
	if index != -1:
		if amount == -1:
			inv.remove_at(index)
		else:
			inv[index].subtract()

func find(item: Object) -> Object:
	for i in inv:
		if i.object == item:
			return i
	return null

func _to_string():
	return str(inv)
