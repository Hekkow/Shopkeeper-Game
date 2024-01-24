extends Node2D

class_name Character

@export var customer: CharacterStats
@onready var pathfinding = $Pathfinding
@onready var shopping = $Shopping
@onready var store = Data.store
@onready var animation = $AnimatedSprite2D
@onready var text_bubble_position = $TextBubblePosition
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
	if Dialogic.current_timeline != null:
		return
	var layout = Dialogic.start(Paths.dialogic_timelines + "Test.dtl")
	for character in Characters.active:
		var path = Paths.dialogic_characters + character.customer.character_name + ".dch"
		if !ResourceLoader.exists(path):
			continue
		layout.register_character(load(path), character.text_bubble_position)
	layout.register_character(load(Paths.dialogic_characters + "Player.dch"), Characters.player.text_bubble_position)

func _exit_tree():
	Dialogic.end_timeline()
	Characters.remove(self)

func destination_reached():
	if SceneManager.state == SceneManager.Scene.Store:
		shopping.destination_reached()
	animation.stop_animation()



func _to_string() -> String:
	return customer.character_name

func equals(character: Character) -> bool:
	return customer.character_name == character.customer.character_name
		
