extends Resource

class_name CharacterStats

@export var character_name: String
@export var color: Color
@export var richness: int
@export var friendship: int
@export var personality: Personality
@export var mood: Mood
@export var affinity: Array[Recipe]

func _to_string() -> String:
    return "%s [Richness: %s, Friendship: %s, Personality: %s, Mood: %s, Affinity: %s]" % [character_name, richness, friendship, personality, mood, affinity]

func equals(character: CharacterStats) -> bool:
    return character_name == character.character_name