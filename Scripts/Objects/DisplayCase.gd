extends Node2D

class_name DisplayCase

var item: Item
func _ready():
	SignalManager.connect("store_initialized", on_store_initialized)

func on_store_initialized():
	Data.store.display_cases.append(self)
	Data.store.astar.set_point_solid(Data.store.tilemap.local_to_map(position))