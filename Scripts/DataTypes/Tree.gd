extends Node

class_name Treee

var data

var branches = []

var parent

var level: int

func _init(_data, _parent=null, _level=0):
	data = _data
	parent = _parent
	level = _level

func add(_data):
	var new_branch = Treee.new(_data, self, level + 1)
	branches.append(new_branch)
	return new_branch
func add_tree(tree):
	tree.level = level + 1
	tree.parent = self
	branches.append(tree)
func _to_string():
	var string = ""
	if parent != null:
		string += "\n"
	for i in level:
		string += "  "
	string += data
	for branch in branches:
		string += str(branch)
	return string