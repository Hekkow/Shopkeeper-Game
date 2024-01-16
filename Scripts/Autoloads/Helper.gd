extends Node

enum Direction { UP, LEFT, DOWN, RIGHT, NONE}

func remove_children(node: Node) -> void:
	for n in node.get_children():
		node.remove_child(n)
		n.queue_free()

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

func find_index(arr: Array, item) -> int:
	for i in len(arr):
		if item.equals(arr[i]):
			return i
	return -1
func find(arr: Array, item):
	for i in arr:
		if item.equals(i):
			return i
func remove(arr: Array, item: Object) -> void:
	for i in range(arr.size() - 1, -1, -1):
		if item.equals(arr[i]):
			arr.remove_at(i)

func empty_and_delete(arr: Array) -> void:
	for i in range(arr.size() - 1, -1, -1):
		arr[i].queue_free()
		arr.remove_at(i)

func cardinal_direction(direction: Vector2): #- in reverse because 0, 0 is top left corner
	if direction == Vector2.ZERO:
		return Direction.NONE
	if abs(direction.x) > abs(direction.y):
		if direction.x < 0:
			return Direction.RIGHT
		else:
			return Direction.LEFT
	else:
		if direction.y < 0:
			return Direction.UP
		else:
			return Direction.DOWN