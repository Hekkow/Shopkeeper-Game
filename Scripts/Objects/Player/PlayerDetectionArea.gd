extends Area2D

var bodies = []


func _ready():
	area_entered.connect(on_area_entered)
	area_exited.connect(on_area_exited)
func on_area_entered(body):
	if body.customer:
		var button_prompt = load("res://Scenes/UI/ButtonPrompt.tscn").instantiate()
		button_prompt.name = "ButtonPrompt"
		body.add_child(button_prompt)
		button_prompt.position = Vector2(25, -50)
		bodies.append(body)
func on_area_exited(body):
	var index = bodies.find(body)
	if index != -1:
		body.get_node("ButtonPrompt").queue_free()
		bodies.remove_at(index)

func _input(event):
	if event.is_action_pressed("interact"):
		if bodies[0].has_method("interact"):
			bodies[0].interact()