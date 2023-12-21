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

func get_file_names(path):
	var dir = DirAccess.open(path)
	var paths = []
	if dir:
		dir.list_dir_begin()
		var file_name = dir.get_next()
		while file_name != "":
			paths.append(file_name)
			file_name = dir.get_next()
	return paths

func num_files(path):
	var dir = DirAccess.open(path)
	var n = 0
	if dir:
		dir.list_dir_begin()
		var file_name = dir.get_next()
		while file_name != "":
			n += 1
			file_name = dir.get_next()
	return n

func get_resources(folder):
	var folder_path = "res://Resources/" + folder
	var resources = []
	var paths = get_file_names(folder_path)
	for path in paths:
		resources.append(load(folder_path + "/" + path))
	return resources