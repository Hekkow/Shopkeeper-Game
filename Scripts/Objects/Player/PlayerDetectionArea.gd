extends Area2D

var bodies = []

var interact_with

@onready var parent = get_parent()

func _ready():
	area_entered.connect(on_area_entered)
	area_exited.connect(on_area_exited)

func on_area_entered(body):
	if body.has_method("interact"):
		bodies.append(body)
	if body.get_parent() && body.get_parent().has_method("interact"):
		bodies.append(body.get_parent())

func on_area_exited(body):
	var index = bodies.find(body)
	if index != -1:
		bodies.remove_at(index)
	if body.get_parent():
		var index_parent = bodies.find(body.get_parent())
		if index_parent != -1:
			bodies.remove_at(index_parent)

func _process(_delta):
	# print(bodies)
	if len(bodies) == 0:
		if interact_with:
			interact_with.get_node("ButtonPrompt").queue_free()
			interact_with = null
		return
	var closest_interactable = bodies[0]
	for body in bodies:
		if body.position.distance_to(parent.position) < closest_interactable.position.distance_to(parent.position) && body.interactable:
			closest_interactable = body
	if !closest_interactable.interactable:
		if interact_with:
			interact_with.get_node("ButtonPrompt").queue_free()
			interact_with = null
		return
	if closest_interactable != interact_with:
		if interact_with != null:
			interact_with.get_node("ButtonPrompt").queue_free()
		var button_prompt = load("res://Scenes/UI/ButtonPrompt.tscn").instantiate()
		button_prompt.name = "ButtonPrompt"
		closest_interactable.add_child(button_prompt)
		button_prompt.position = Vector2(25, -50)
		interact_with = closest_interactable

func _input(event):
	if event.is_action_pressed("interact"):
		if interact_with != null:
			interact_with.interact()
