extends Node

class_name Conversation

var conversation: String #- conversation name
var character: String

func _init(_character, _conversation):
	conversation = _conversation
	character = _character

func equals(_conversation): #- conversation object
	return _conversation.conversation == conversation && _conversation.character == character

func _to_string():
	return "[%s] %s" % [character, conversation]
