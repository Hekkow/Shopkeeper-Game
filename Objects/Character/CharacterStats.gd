extends Resource

class_name CharacterStats

@export var character_name: String
@export var color: Color

func _to_string() -> String:
    return "%s" % [character_name]

func equals(character: CharacterStats) -> bool:
    return character_name == character.character_name