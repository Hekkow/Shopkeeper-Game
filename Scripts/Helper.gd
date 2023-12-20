extends Node

func find_by_metadata(obj, key, value):
	for child in obj.get_children():
		if child.get_meta(key) == value:
			return child
	return null
func remove_freed(arr):
	for i in arr.duplicate():
		if !is_instance_valid(i):
			arr.erase(i)

func len_without_deleted(arr):
	var n = 0
	for i in arr:
		if is_instance_valid(i):
			n += 1
	return n