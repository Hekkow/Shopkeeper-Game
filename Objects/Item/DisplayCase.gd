extends Node2D

class_name DisplayCase

var item: Item
func _ready():
	SignalManager.connect("level_ready", on_level_ready)

func on_level_ready(_level):
	Data.store.display_cases.append(self)
	Data.store.astar.set_point_solid(Data.store.tilemap.local_to_map(position) + Vector2i(0, -1)) # for y sort, needs to be 1 block higher because 0, 0 is at bottom