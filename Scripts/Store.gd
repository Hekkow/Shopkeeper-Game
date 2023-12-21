extends Node2D

var colors = [Color(0, 0, 255), Color(0, 255, 0), Color(255, 0, 0)]

func _ready():
	spawn_items(3)
	spawn_customers(5)

func spawn_items(number_items):
	var scene := load("res://item.tscn")
	var recipes = choose_items(number_items)
	var radius = 500.0
	var max_angle = 90.0 * PI /180
	for i in len(recipes):
		var item = scene.instantiate()
		item.name = recipes[i].recipe_name
		item.recipe = recipes[i]
		var x = radius * cos(max_angle/(len(recipes)+1)*(i+1))
		var y = radius * sin(max_angle/(len(recipes)+1)*(i+1))
		item.set_position(Vector2(x, y))
		add_child(item)

func spawn_customers(number_customers):
	var scene := load("res://Character.tscn")
	var customers = choose_customers(number_customers)
	for customer in customers:
		var character = scene.instantiate()
		character.name = customer.character_name
		character.get_node("Sprite2D").modulate = customer.color
		character._init(customer)
		add_child(character)
		await get_tree().create_timer(1).timeout

func choose_items(number_items):

	return Helper.random_sample(Data.all["Recipes"], number_items)

func choose_customers(number_customers):
	# return [Helper.get_character("Green"), Helper.get_character("Blue"), Helper.get_character("Orange"), Helper.get_character("Salmon"), Helper.get_character("Red")]
	# return [Data.all["Characters"][2], Data.all["Characters"][3], Data.all["Characters"][4]]
	return Helper.random_sample(Data.all["Characters"], number_customers)