extends CharacterBody2D

class_name Player

const speed = 300.0
var dir: Vector2
@onready var animation = $AnimatedSprite2D
@onready var text_bubble_position = $TextBubblePosition

func _ready():
	Characters.player = self
	SignalManager.connect("level_ready", on_level_ready)

func on_level_ready(level):
	position = level.get_entry_position()

func _physics_process(_delta):
	velocity = dir * speed
	animation.walk_animation(dir)
	move_and_slide()

func _input(_event):
	if UI.in_ui:
		return
	dir.x = Input.get_axis("ui_left", "ui_right")
	dir.y = Input.get_axis("ui_up", "ui_down")
	dir = dir.normalized()
