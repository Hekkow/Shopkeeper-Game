extends CharacterBody2D


const speed = 300.0
var dir: Vector2
@onready var animated_sprite = $AnimatedSprite2D

func _ready():
	Characters.player = self

func _physics_process(_delta):
	velocity = dir * speed
	match Helper.cardinal_direction(dir):
		Helper.Direction.UP:
			animated_sprite.play("up")
		Helper.Direction.DOWN:
			animated_sprite.play("down")
		Helper.Direction.LEFT:
			animated_sprite.play("side")
			animated_sprite.flip_h = true
		Helper.Direction.RIGHT:
			animated_sprite.play("side")
			animated_sprite.flip_h = false
		Helper.Direction.NONE:
			animated_sprite.stop()
	move_and_slide()

func _unhandled_input(_event):
	dir.x = Input.get_axis("ui_left", "ui_right")
	dir.y = Input.get_axis("ui_up", "ui_down")
	dir = dir.normalized()