extends Node

var seen_today = []
var world_ingredients = {}

func _ready():
	SignalManager.connect("next_day", on_day_start)

func on_day_start(_day):
	seen_today = []
	world_ingredients = {}