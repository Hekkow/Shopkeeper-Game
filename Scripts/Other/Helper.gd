extends Node

func find_by_metadata(obj: Node, key: String, value) -> Node:
	for child in obj.get_children():
		if child.get_meta(key) == value:
			return child
	return null

func remove_children(node: Node) -> void:
	for n in node.get_children():
		node.remove_child(n)
		n.queue_free()

func get_all_children(grandfather, arr=[]) -> Array:
	arr.push_back(grandfather)
	for child in grandfather.get_children():
		arr = get_all_children(child, arr)
	return arr

func set_children_mouse_filter(parent, value):
	parent.mouse_filter = value
	for node in get_all_children(parent):
		if "mouse_filter" in node:
			node.mouse_filter = value

func get_file_names(path: String) -> Array:
	var dir = DirAccess.open(path)
	var paths = []
	if dir:
		dir.list_dir_begin()
		var file_name = dir.get_next()
		while file_name != "":
			paths.append(file_name)
			file_name = dir.get_next()
	return paths

func num_files(path: String) -> int:
	var dir = DirAccess.open(path)
	var n = 0
	if dir:
		dir.list_dir_begin()
		var file_name = dir.get_next()
		while file_name != "":
			n += 1
			file_name = dir.get_next()
	return n

func get_resources(folder: String) -> Array:
	var folder_path = "res://Resources/" + folder
	var resources = []
	var paths = get_file_names(folder_path)
	for path in paths:
		resources.append(load(folder_path + "/" + path))
	return resources

func random_sample(_arr: Array, number_elements: int) -> Array:
	var arr = _arr.duplicate()
	var elements = []
	for i in number_elements:
		var index = Data.rng.randi_range(0, len(arr) - 1)
		elements.append(arr[index])
		arr.remove_at(index)
	return elements

func find_item(arr: Array, item: Object) -> int:
	for i in len(arr):
		if item.equals(arr[i]):
			return i
	return -1
func remove_item(arr: Array, item: Object) -> void:
	for i in range(arr.size() - 1, -1, -1):
		if item.equals(arr[i]):
			arr.remove_at(i)
