extends Node2D

var colors = [Color(255, 0, 0), Color(0, 255, 0), Color(0, 0, 255)]
var customer_name = ["Red", "Green", "Blue"]

func _ready():
	spawn_customers(3)

func spawn_customers(number_customers):
	var scene := load("res://customer.tscn")
	for i in number_customers:
		var customer = scene.instantiate()
		customer.get_node("Sprite2D").modulate = colors[i]
		customer.speed = 3
		customer.character_name = customer_name[i]
		add_child(customer)
		await get_tree().create_timer(1).timeout
