extends Node

var list: Array
var max_richness = 5
var max_friendship = 5

func _ready():
	list = Helper.get_resources("Characters")
