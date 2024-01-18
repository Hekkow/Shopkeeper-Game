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
	if GameState.state == GameState.State.Shopping:
		shopping.start()
	elif GameState.state == GameState.State.World:
		pass

func haggle():
	shopping.haggle()

func interact():
	var conversation = load("res://Scenes/UI/TextBubbles/Conversation.tscn").instantiate()
	conversation.init("Black-convo")
	get_parent().add_child(conversation)
	print(str(self) + " interacted")

func destination_reached():
	if GameState.state == GameState.State.Shopping:
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
	Helper.remove(store.customers, self)

func _to_string() -> String:
	return customer.character_name

func equals(character: Character) -> bool:
	return customer.character_name == character.customer.character_name
		
