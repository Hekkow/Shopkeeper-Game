extends Control

class_name Conversation

func _init():
	var layout = Dialogic.start("timeline")
	layout.register_character(load("res://character.dch"), Characters.get_active_character("Black"))
	layout.register_character(load("res://player.dch"), Characters.player)
	pass