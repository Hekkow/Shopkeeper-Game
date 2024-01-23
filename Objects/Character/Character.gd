extends Node2D

class_name Character

@export var customer: CharacterStats
@onready var pathfinding = $Pathfinding
@onready var shopping = $Shopping
@onready var store = Data.store
@onready var animated_sprite = $AnimatedSprite2D
var interactable = true

func _init(_customer: CharacterStats = null):
	customer = _customer

func _ready():
	Characters.active.append(self)
	if SceneManager.state == SceneManager.Scene.Store:
		interactable = false
		shopping.start()

func haggle():
	shopping.haggle()

func interact():
	Conversation.new()

func destination_reached():
	if SceneManager.state == SceneManager.Scene.Store:
		shopping.destination_reached()
	stop_animation()

func stop_animation():
	animated_sprite.stop()

func walk_animation(direction):
	match direction:
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

func _exit_tree():
	Characters.remove(self)

func _to_string() -> String:
	return customer.character_name

func equals(character: Character) -> bool:
	return customer.character_name == character.customer.character_name
		
