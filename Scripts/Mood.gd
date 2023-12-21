extends Resource

class_name Mood

@export var mood: MOOD

enum MOOD {HAPPY, SAD, MAD, NA}

func _init(_mood):
    mood = _mood
