extends Node2D

var colors = [Color(0, 0, 255), Color(0, 255, 0), Color(255, 0, 0)]

func _ready():
	spawn_items()
	spawn_customers()
	

func spawn_items():
	var scene := load("res://item.tscn")
	var radius = 500.0
	var max_angle = 90.0 * PI /180
	var number_recipes = len(Data.all["Recipes"])
	for i in number_recipes:
		var item = scene.instantiate()
		item.name = Data.all["Recipes"][i].recipe_name
		item.recipe = Data.all["Recipes"][i]
		var x = radius * cos(max_angle/(number_recipes+1)*(i+1))
		var y = radius * sin(max_angle/(number_recipes+1)*(i+1))
		item.set_position(Vector2(x, y))
		add_child(item)

func spawn_customers():
	var scene := load("res://Character.tscn")
	for i in range(len(Data.all["Characters"])):
		var customer = scene.instantiate()
		customer.name = Data.all["Characters"][i].character_name
		customer.get_node("Sprite2D").modulate = colors[i]
		customer._init(Data.all["Characters"][i])
		add_child(customer)
		await get_tree().create_timer(1).timeout
