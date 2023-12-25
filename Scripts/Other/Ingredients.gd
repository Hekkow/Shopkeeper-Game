extends Node

var list: Array
var inventory = Inventory.new()
var pot = Inventory.new()

func _ready():
	list = Helper.get_resources("Ingredients")
	# temp
	for i in list:
		inventory.add(i, 10)