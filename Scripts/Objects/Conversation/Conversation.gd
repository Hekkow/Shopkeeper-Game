extends Control

var text_bubble_scene = load("res://Scenes/UI/TextBubbles/TextBubble.tscn")
var text_bubble_script = load("res://Scripts/Objects/Conversation/TextBubble.gd")
var text_tree: TextTreee
var previous_bubbles = []
var height = -135
var width = 135.0
var seperation = 20.0
var extra_height_3 = -30.0
var extra_height_5 = -50.0
var minus_height = 10
var placements = [
	[],
	[Vector2(-width/2, height)],
	[Vector2(-width-seperation/2, height), Vector2(seperation/2, height)],
	[Vector2(-width/2-seperation/2-width, height), Vector2(-width/2, height+extra_height_3), Vector2(seperation/2+width/2, height)],
	[Vector2(-width*2, height), Vector2(-width-seperation/4, height+extra_height_3), Vector2(seperation/4, height+extra_height_3), Vector2(width, height)],
	[Vector2(-width/2-width*2, height+minus_height), Vector2(-width/2-seperation/2-width, height+extra_height_3), Vector2(-width/2, height+extra_height_5), Vector2(seperation/2+width/2, height+extra_height_3), Vector2(width+width/2, height+minus_height)]
]

func _ready():
	SignalManager.connect("text_pressed", on_text_pressed)
	SignalManager.connect("conversation_done", on_conversation_done)
	create_text_bubbles([text_tree])

func init(file_name):
	text_tree = load_file(file_name)
	
func create_text_bubbles(arr):
	var character
	if arr[0].speaker == "Player":
		character = Characters.player
	else:
		character = Characters.get_active_character(arr[0].speaker)
	if character == null:
		return
	for i in len(arr):
		var text_bubble = text_bubble_scene.instantiate()
		text_bubble.set_script(text_bubble_script)
		text_bubble.set_variables(arr[i])
		character.add_child(text_bubble)
		text_bubble.position = placements[len(arr)][i]
		previous_bubbles.append(text_bubble)
		

func on_text_pressed(_text_tree):
	Helper.empty_and_delete(previous_bubbles)
	create_text_bubbles(_text_tree.branches)

func on_conversation_done(_text_tree):
	Helper.empty_and_delete(previous_bubbles)
	queue_free()

func load_file(file_name):
	var file = FileAccess.open("res://Resources/Conversations/" + file_name + ".txt", FileAccess.READ)
	var lines = []
	while true:
		var line = file.get_line()
		if line == "":
			break
		lines.append(line)
	var root_data = get_data_line(lines[0])
	var tree = TextTreee.new(root_data[0], root_data[1])
	var branches = [tree]
	for i in range(1, len(lines)):
		var data = get_data_line(lines[i])
		var node = TextTreee.new(data[0].strip_edges(), data[1])
		var level = get_level(data[0])
		for y in range(i-1, -1, -1):
			if branches[y].level == level - 1:
				branches[y].add_tree(node)
				branches.append(node)
				break	
	file.close()
	return tree


func get_data_line(line):
	var both = line.split(":")
	var speaker = both[0]
	var text = both[1].substr(1)
	return [speaker, text]

func get_level(speaker):
	var level = 0
	for i in speaker:
		if i == " ":
			level += 0.5
		else:
			break
	return level
