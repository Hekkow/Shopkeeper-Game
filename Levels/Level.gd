extends Node2D

class_name Level

var tilemap: TileMap
var astar: AStarGrid2D
var ground_layer = 0
var solid_layers = []
var exits = []

#- need to set name of root node, add triggers with to variable set, add player, add tilemapgenerator

func _ready():
	SceneManager.scene = self
	level_ready()

func level_ready():
	SignalManager.emit_signal("level_ready", self)

func get_entry_position(previous = null):
	for exit in exits:
		if previous:
			if exit.to == previous:
				return exit.position + exit.spawn_point
		elif exit.to == SceneManager.previous_scene:
			return exit.position + exit.spawn_point