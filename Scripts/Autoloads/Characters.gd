extends Node

var list: Array
var max_richness = 5
var max_friendship = 5

func _ready():
	list = Helper.get_resources("Characters")

func get_character(character_name: String) -> Character:
	for character in list:
		if character_name == character.character_name:
			return character
	return null
