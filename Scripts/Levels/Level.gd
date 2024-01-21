extends Node2D

class_name Level

var tilemap: TileMap
var astar: AStarGrid2D
var exit

func level_ready():
	SignalManager.emit_signal("level_ready", self)