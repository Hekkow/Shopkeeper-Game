extends Node2D

class_name DisplayCase

var item: Item
var pos
func _ready():
	SignalManager.connect("level_ready", on_level_ready)

func on_level_ready(level):
	level.display_cases.append(self)
	level.astar.set_point_solid(Data.store.tilemap.local_to_map(position) + Vector2i(0, -1)) # for y sort, needs to be 1 block higher because 0, 0 is at bottom
	pos = level.tilemap.local_to_map(position)

func equals(case: DisplayCase):
	return pos == case.pos