extends Control

var conversations_seen = []
var conversations = []

func _ready():
	SignalManager.connect("scene_changing", on_scene_changing)
	load_conversations()

func load_conversations():
	var dir = DirAccess.open(Paths.dialogic_timelines)
	dir.list_dir_begin()
	var file_name = dir.get_next()
	while file_name != "":
		var file = FileAccess.open(Paths.dialogic_timelines + file_name, FileAccess.READ)
		conversations.append(Conversation.new(file.get_line().split(":")[0], file_name.split(".")[0]))
		file_name = dir.get_next()

func on_scene_changing(_to):
	Dialogic.end_timeline()

func start(character):
	if Dialogic.current_timeline != null:
		return
	start_conversation(get_conversation(character))

func get_conversation(character):
	var timeline_name = null
	match character.customer.character_name:
		"Black":
			if !seen("Black", "Test"):
				timeline_name = "Test"
			else:
				timeline_name = "Test1"
	if timeline_name == null:
		return null
	return Conversation.new(character.customer.character_name, timeline_name)

func available(character): #- checks if any conversation is available
	var conversation = get_conversation(character)
	if conversation == null || seen(conversation.character, conversation.conversation):
		return false
	return true

func seen(character, conversation): #- checks specific conversation seen
	if Helper.find_index(conversations_seen, Conversation.new(character, conversation)) == -1:
		return false
	return true


func start_conversation(conversation):
	if conversation == null:
		return
	if seen(conversation.character, conversation.conversation):
		return
	var layout = Dialogic.start(Paths.dialogic_timelines + conversation.conversation + ".dtl")
	register_all(layout)
	conversations_seen.append(conversation)
	SignalManager.emit_signal("conversation_started", conversation)


func register_all(layout):
	for character in Characters.active:
		var path = Paths.dialogic_characters + character.customer.character_name + ".dch"
		if !ResourceLoader.exists(path):
			continue
		layout.register_character(load(path), character.text_bubble_position)
	layout.register_character(load(Paths.dialogic_characters + "Player.dch"), Characters.player.text_bubble_position)
