extends Node

class_name Queue

var items

func _init():
	items = []

func add(item):
	items.append(item)

func get_first():
	if len(items) == 0:
		return null
	var item = items[0]
	items.remove_at(0)
	return item
