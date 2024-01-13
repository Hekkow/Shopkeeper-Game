extends Node

class_name Queue

var items

var n = 0

func _init():
	items = []

func add(item):
	items.append(item)
	n += 1

func get_first():
	if len(items) == 0:
		return null
	var item = items[0]
	items.remove_at(0)
	n -= 1
	return item

func place_in_line(item):
	return items.find(item)

func in_line(item):
	return items.has(item)