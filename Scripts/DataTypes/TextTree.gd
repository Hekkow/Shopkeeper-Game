extends Treee

class_name TextTreee

var speaker

func _init(_speaker, _data, _parent=null, _level=0):
	speaker = _speaker
	super(_data, _parent, _level)

func add_text(_speaker, _data):
	var new_branch = TextTreee.new(_speaker, _data, self, level + 1)
	branches.append(new_branch)
	return new_branch

func _to_string():
	var string = ""
	if parent != null:
		string += "\n"
	for i in level:
		string += "  "
	string += speaker + ": " + data
	for branch in branches:
		string += str(branch)
	return string
