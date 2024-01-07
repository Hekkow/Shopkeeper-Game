@tool
extends Control

var bubbles = []

signal reset_pressed

var dragging_bubble
var grabbed_from
var from
var to
var connections = []

var zoom_level = 1
var n = 0
var panning = false

var tree

var pan_start_pos

func reset():
	for i in range(len(bubbles) -1, -1, -1):
		bubbles[i].queue_free()
	bubbles = []
	from = null
	to = null
	connections = []
	tree_edited()
	zoom_level = 1
	scale = Vector2(zoom_level, zoom_level)
	position = Vector2(0, 0)

func on_bubble_removed(bubble):
	var found = false
	for i in range(len(connections) -1, -1, -1):
		if connections[i].has(bubble):
			connections.remove_at(i)
			found = true
			queue_redraw()
	tree_edited()
	if !found:
		bubbles.remove_at(bubbles.find(bubble))
		bubble.queue_free()

func _ready():
	call_deferred("set_size", Vector2(10000, 10000))

func _input(event):
	if event is InputEventMouseButton:
		if event.double_click:
			if get_local_mouse_position().x < 0 || get_local_mouse_position().y < 0 || get_local_mouse_position().x > size.x:
				return 
			var text_bubble = load("res://addons/Editor/TextGenBubble.tscn").instantiate()
			text_bubble.position = get_local_mouse_position() - text_bubble.size/2
			add_child(text_bubble)
			text_bubble.connect("bubble_removed", on_bubble_removed)
			text_bubble.connect("bubble_clicked", on_bubble_clicked)
			text_bubble.connect("dragging_started", on_dragging_started)
			text_bubble.connect("dragging_ended", on_dragging_ended)
			text_bubble.connect("text_changed", on_text_changed)
			text_bubble.get_node("MarginContainer/VBoxContainer/TextEdit").connect("enter_pressed", on_text_changed)
			text_bubble.name = str(n)
			n += 1
			bubbles.append(text_bubble)
		elif event.button_index == MOUSE_BUTTON_WHEEL_UP:
			set_zoom(true)
		elif event.button_index == MOUSE_BUTTON_WHEEL_DOWN:
			set_zoom(false)
		elif event.button_index == MOUSE_BUTTON_MIDDLE:
			if event.pressed:
				pan_start_pos = get_global_mouse_position() - global_position
				panning = true
			else:
				panning = false

func on_text_changed():
	tree_edited()

func tree_edited():
	var root = find_root()
	if root == null:
		return
	var data = get_data(root)
	tree = TextTreee.new(data[0], data[1])
	find_branches(root, tree)
	print(tree)

func find_branches(node, _tree):
	var branches = []
	for i in range(len(connections)):
		if connections[i][0] == node:
			branches.append(connections[i][1])
	
	for i in len(branches):
		var data = get_data(branches[i])
		var new_tree = _tree.add_text(data[0], data[1])
		find_branches(branches[i], new_tree)

func get_data(node):
	return [node.get_node("MarginContainer/VBoxContainer/LineEdit").text, node.get_node("MarginContainer/VBoxContainer/TextEdit").text]


func find_root():
	var trees = []
	for i in len(connections):
		if !trees.has(connections[i][0]):
			trees.append(connections[i][0])
		if !trees.has(connections[i][1]):
			trees.append(connections[i][1])
	for i in len(trees):
		var found = false
		for n in len(connections):
			if connections[n][1] == trees[i]:
				found = true
		if !found:
			return trees[i]
func _process(delta):
	if panning:
		global_position = get_global_mouse_position() - pan_start_pos
	if dragging_bubble != null:
		dragging_bubble.position = get_local_mouse_position() - grabbed_from
		queue_redraw()

func set_zoom(zoom_in):
	if zoom_in:
		zoom_level *= 1.05
	else:
		zoom_level /= 1.05
	if zoom_level < 0.2:
		zoom_level = 0.2
	scale = Vector2(zoom_level, zoom_level)
	

func on_dragging_started(bubble, mouse_pos):
	dragging_bubble = bubble
	grabbed_from = mouse_pos
	from = null
	to = null

func on_dragging_ended():
	if dragging_bubble == null:
		return
	var new_stylebox_panel = dragging_bubble.get_theme_stylebox("panel").duplicate()
	new_stylebox_panel.border_width_top = 0
	dragging_bubble.add_theme_stylebox_override("panel", new_stylebox_panel)
	dragging_bubble = null

func on_bubble_clicked(bubble, mouse_pos):
	if bubble == to:
		var new_stylebox_panel = bubble.get_theme_stylebox("panel").duplicate()
		new_stylebox_panel.border_width_top = 0
		bubble.add_theme_stylebox_override("panel", new_stylebox_panel)
		from = null
		to = null
		return
	else:
		var new_stylebox_panel = bubble.get_theme_stylebox("panel").duplicate()
		new_stylebox_panel.border_width_top = 3
		new_stylebox_panel.border_color = Color(0, 1, 0.5)
		bubble.add_theme_stylebox_override("panel", new_stylebox_panel)
	from = to
	to = bubble
	if from != null:
		var found = false
		for i in len(connections):
			if connections[i].has(from) && connections[i].has(to):
				found = true
				connections[i] = [connections[i][1], connections[i][0]]

		var new_stylebox_panel = bubble.get_theme_stylebox("panel").duplicate()
		new_stylebox_panel.border_width_top = 0
		from.add_theme_stylebox_override("panel", new_stylebox_panel)
		to.add_theme_stylebox_override("panel", new_stylebox_panel)
		if !found:
			connections.append([from, to])
		tree_edited()
		from = null
		to = null
		queue_redraw()
		






func _draw():
	for connection in connections:
		var corners = closest_corners(connection[0], connection[1])
		draw_line(corners[0], corners[1], Color.GREEN, 3)
		draw_circle(corners[1], 5, Color.GREEN)
		
		
func get_corners(box):
	var corners = []
	corners.append(box.position)
	corners.append((box.position + Vector2(box.size.x/2 * zoom_level, 0)))
	corners.append((box.position + Vector2(box.size.x * zoom_level, 0)))
	corners.append((box.position + Vector2(box.size.x * zoom_level, box.size.y/2 * zoom_level)))
	corners.append((box.position + box.size * zoom_level))
	corners.append((box.position + Vector2(box.size.x/2 * zoom_level, box.size.y * zoom_level)))
	corners.append((box.position + Vector2(0, box.size.y * zoom_level)))
	corners.append((box.position + Vector2(0, box.size.y/2 * zoom_level)))
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



	

