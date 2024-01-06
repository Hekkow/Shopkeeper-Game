@tool
extends Control

var bubbles = []

signal reset_pressed

var dragging_bubble
var grabbed_from
var from
var to
var connections = []

var n = 0

func reset():
	for i in range(len(bubbles) -1, -1, -1):
		bubbles[i].queue_free()
	bubbles = []
	from = null
	to = null
	connections = []

func on_bubble_removed(bubble):
	bubbles.remove_at(bubbles.find(bubble))
	bubble.queue_free()

func _input(event):
	if event is InputEventMouseButton and event.double_click:
		if get_local_mouse_position().x < 0 || get_local_mouse_position().y < 0 || get_local_mouse_position().x > size.x:
			return 
		var text_bubble = load("res://addons/Editor/TextGenBubble.tscn").instantiate()
		text_bubble.position = get_local_mouse_position() - text_bubble.size/2
		add_child(text_bubble)
		text_bubble.connect("bubble_removed", on_bubble_removed)
		text_bubble.connect("bubble_clicked", on_bubble_clicked)
		text_bubble.connect("dragging_started", on_dragging_started)
		text_bubble.connect("dragging_ended", on_dragging_ended)
		text_bubble.name = str(n)
		n += 1
		bubbles.append(text_bubble)
		
func on_dragging_started(bubble, mouse_pos):
	print("HERE")
	dragging_bubble = bubble
	grabbed_from = mouse_pos
	from = null
	to = null

func on_dragging_ended():
	dragging_bubble = null

func on_bubble_clicked(bubble, mouse_pos):
	from = to
	to = bubble
	to.get_theme_stylebox("panel").bg_color = Color.WHITE
	if from != null:
		connections.append([from, to])
		from = null
		to = null
		queue_redraw()
		
func _process(delta):
	if dragging_bubble != null:
		dragging_bubble.position = get_local_mouse_position() - grabbed_from
		queue_redraw()
				

func _draw():
	for connection in connections:
		var corners = closest_corners(connection[0], connection[1])
		draw_line(corners[0], corners[1], Color.GREEN)
		
func get_corners(box):
	var corners = []
	corners.append(box.position + Vector2(box.size.x/2, 0))
	corners.append(box.position + Vector2(box.size.x, box.size.y/2))
	corners.append(box.position + Vector2(box.size.x/2, box.size.y))
	corners.append(box.position + Vector2(0, box.size.y/2))
	return corners

func closest_corners(from, to):
	var smallest_distance = 100000
	var smallest_from
	var smallest_to
	for corner_from in get_corners(from):
		for corner_to in get_corners(to):
			if corner_from.distance_to(corner_to) < smallest_distance:
				smallest_distance = corner_from.distance_to(corner_to)
				smallest_from = corner_from
				smallest_to = corner_to
	return [smallest_from, smallest_to]



	

