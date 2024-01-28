extends Control

var conversations_seen = []
var conversations = []

func _ready():
	SignalManager.connect("scene_changing", on_scene_changing)
	load_conversations()

func get_all_timelines_with_character(character: String):
	var arr = []
	for conversation in conversations:
		if conversation.character == character:
			arr.append(conversation)
	return arr

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
	for timeline in get_all_timelines_with_character(character.customer.character_name):
		if !seen(timeline):
			return timeline
	return null

func available(character): #- checks if any conversation is available
	var conversation = get_conversation(character)
	if conversation == null || seen(conversation):
		return false
	return true

func seen(conversation): #- checks specific conversation seen
	if Helper.find_index(conversations_seen, conversation) == -1:
		return false
	return true

func start_conversation(conversation):
	if conversation == null:
		return
	if seen(conversation):
		return
	var path = Paths.dialogic_timelines + conversation.conversation + ".dtl"
	var layout = Dialogic.start(path)
	register_all(layout, load(path))
	conversations_seen.append(conversation)
	SignalManager.emit_signal("conversation_started", conversation)


func register_all(layout, timeline):
	timeline.process()
	for event in timeline.events:
		if event is DialogicTextEvent and event.character != null:
			if event.character.display_name != "Player":
				layout.register_character(event.character, Characters.get_active_character(event.character.display_name).text_bubble_position)
			else:
				layout.register_character(event.character, Characters.player.text_bubble_position)
