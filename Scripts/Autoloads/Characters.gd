extends Node

var list: Array
var active = []
var max_richness = 5
var max_friendship = 5
var player

func _ready():
	list = Helper.get_resources("Characters")

func get_character(character_name: String) -> Character:
	for character in list:
		if character_name == character.character_name:
			return character
	return null

func get_active_character(character_name: String) -> Character:
	for character in active:
		if character_name == character.customer.character_name:
			return character
	return null
func remove(character: Character):
	Helper.remove(active, character)