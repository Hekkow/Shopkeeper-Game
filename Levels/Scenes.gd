extends Node

var seen_today = []
var world_ingredients = {}
var solids = []

func _ready():
	SignalManager.connect("next_day", on_day_start)
	SignalManager.connect("scene_changing", on_scene_change)

func on_scene_change(_scene):
	solids = []

func on_day_start(_day):
	seen_today = []
	world_ingredients = {}