extends Resource

class_name Mood

@export var mood: MOOD

enum MOOD {HAPPY, SAD, MAD, NA}

func _init(_mood=MOOD.NA):
    mood = _mood
