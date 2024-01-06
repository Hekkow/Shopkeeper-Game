extends Button

var text_tree

func _ready():
	text = text_tree.speaker + ": " + text_tree.data

func _pressed():
	if len(text_tree.branches) == 0:
		SignalManager.emit_signal("conversation_done", text_tree)
	else:
		SignalManager.emit_signal("text_pressed", text_tree)

func set_variables(_text_tree):
	text_tree = _text_tree