extends Node

func find_by_metadata(obj, key, value):
	for child in obj.get_children():
		if child.get_meta(key) == value:
			return child
	return null
