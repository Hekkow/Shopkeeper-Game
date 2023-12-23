extends Resource

class_name Mood

@export var mood: MOOD

enum MOOD {HAPPY, SAD, MAD, NA}

func _init(_mood: MOOD = MOOD.NA) -> void:
    mood = _mood

func _to_string() -> String:
    if mood == MOOD.HAPPY:
        return "Happy"
    if mood == MOOD.SAD:
        return "Sad"
    if mood == MOOD.MAD:
        return "Mad"
    return "NA"