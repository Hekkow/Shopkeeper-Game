extends Node2D

class_name Character

@export var customer: CharacterStats
@onready var pathfinding = $Pathfinding
@onready var shopping = $Shopping
@onready var store = Data.store
@onready var animation = $AnimatedSprite2D
@onready var text_bubble_position = $TextBubblePosition
@onready var schedule = $Schedule
var interactable = true

func set_variables(_customer: CharacterStats = null):
	customer = _customer

func _ready():
	name = customer.character_name
	modulate = customer.color
	Characters.active.append(self)
	update_interactable()
	SignalManager.connect("conversation_started", on_conversation_started)
	if SceneManager.state == SceneManager.Scene.Store:
		interactable = false
		shopping.start()
	elif SceneManager.state == SceneManager.Scene.World:
		schedule.schedule_time_reached.connect(schedule_pathfinding)

func schedule_pathfinding(cell: Vector2i):
	pathfinding.go_to_tile(cell)

func on_conversation_started(conversation):
	if conversation.character != customer.character_name:
		return
	update_interactable()
	
func update_interactable():
	interactable = Dialogue.available(self)

func haggle():
	shopping.haggle()

func interact():
	Dialogue.start(self)

func _exit_tree():
	Characters.remove(self)

func destination_reached():
	if SceneManager.state == SceneManager.Scene.Store:
		shopping.destination_reached()
	animation.stop_animation()

func _to_string() -> String:
	return customer.character_name

func equals(character: Character) -> bool:
	return customer.character_name == character.customer.character_name
		
