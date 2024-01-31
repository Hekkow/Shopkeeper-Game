extends Node2D

@onready var door = $Door
@onready var rect = get_node("StaticBody2D/CollisionShape2D").shape.get_rect()
func _ready():
	door.to = name
	var global_top_left = Vector2(rect.position.x, rect.position.y - rect.size.y / 2) + global_position
	Scenes.solids.append(Rect2(global_top_left, rect.size))
