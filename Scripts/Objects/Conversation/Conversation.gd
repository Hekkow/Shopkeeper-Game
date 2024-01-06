extends Control

var texts = ["test 1", "test 2", "test 3"]
var text_bubble_scene = load("res://Scenes/UI/TextBubbles/TextBubble.tscn")
var text_bubble_script = load("res://Scripts/Objects/Conversation/TextBubble.gd")
var text_tree: TextTreee
var button_size = 275
var button_spacing = 5

func _ready():
	SignalManager.connect("text_pressed", on_text_pressed)
	SignalManager.connect("conversation_done", on_conversation_done)
	initialize_text_tree()
	print(text_tree)
	create_text_bubbles([text_tree])

func initialize_text_tree():
	text_tree = TextTreee.new("guy", "text 1")

	var text2 = TextTreee.new("dude", "text 2")
	
	var text5 = TextTreee.new("guy", "text 5")
	var text6 = TextTreee.new("guy", "text 6")

	var text3 = TextTreee.new("dude", "text 3")

	var text4 = TextTreee.new("dude", "text 4")

	var text7 = TextTreee.new("guy", "text 7")
	var text8 = TextTreee.new("guy", "text 8")
	var text9 = TextTreee.new("guy", "text 9")

	var conversation_finisher = TextTreee.new("dude", "ok bye")

	text_tree.add_tree(text2)
	text2.add_tree(text5)
	# text2without6.add_tree(text5)
	text2.add_tree(text6)
	# text6.add_tree(text2without6)
	text_tree.add_tree(text3)
	text_tree.add_tree(text4)
	text4.add_tree(text7)
	text4.add_tree(text8)
	text4.add_tree(text9)

	text5.add_tree(conversation_finisher)
	text7.add_tree(conversation_finisher)
	text8.add_tree(conversation_finisher)
	text9.add_tree(conversation_finisher)
	
func create_text_bubbles(arr):
	for i in len(arr):
		var text_bubble = text_bubble_scene.instantiate()
		text_bubble.set_script(text_bubble_script)
		text_bubble.set_variables(arr[i])
		text_bubble.position = Vector2((button_size + button_spacing)*i, 0)
		add_child(text_bubble)

func on_text_pressed(_text_tree):
	Helper.remove_children(self)
	create_text_bubbles(_text_tree.branches)

func on_conversation_done(_text_tree):
	Helper.remove_children(self)
	print("CONVERSATION DONE")