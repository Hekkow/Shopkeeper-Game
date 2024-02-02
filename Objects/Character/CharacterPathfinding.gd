extends Node2D

class_name CharacterPathfinding

var store
var tilemap
var astar
@onready var parent = get_parent()
@onready var shopping = get_node("../Shopping")
@onready var animation = get_node("../AnimatedSprite2D")
@export var paused := false
@export var debug_draw = true
@export var path: Array

var min_distance := 3
var speed := 3

func _ready():
	if SceneManager.state == SceneManager.Scene.Store:
		store = Data.store
		tilemap = Data.store.tilemap
		astar = Data.store.astar
		parent.position = Data.store.get_entry_position("World")
	elif SceneManager.state == SceneManager.Scene.World:
		SignalManager.connect("level_ready", on_level_ready)
		
func on_level_ready(level):
	tilemap = level.tilemap
	astar = level.astar
	
func go_to(state, item=null):
	if SceneManager.state == SceneManager.Scene.Store:
		if state == shopping.State.LOOKING:
			set_destination_path(tilemap.local_to_map(item.position) + Vector2i(0, 1))
		elif state == shopping.State.LINE:
			set_destination_path(store.table.get_place(parent))
		elif state == shopping.State.LEAVING:
			set_destination_path(tilemap.local_to_map(Data.store.get_entry_position("World")))

func go_to_tile(cell: Vector2i):
	set_destination_path(cell)

func set_destination_path(destination: Vector2i):
	if path && parent.position.distance_to(tilemap.map_to_local(path[0])) > min_distance:
		path = get_shortest_path(path[0], destination)
	else:
		path = get_shortest_path(tilemap.local_to_map(parent.position), destination)
	set_physics_process(true)

func get_shortest_path(_start: Vector2i, destination: Vector2i) -> Array:
	if !astar.is_point_solid(destination):
		return astar.get_id_path(_start, destination)
	var shortest_path = astar.get_id_path(_start, tilemap.get_neighbor_cell(destination, 0))
	for i in range(4, 12+1, 4):
		var neighbor_cell = tilemap.get_neighbor_cell(destination, i)
		if astar.is_point_solid(neighbor_cell):
			continue
		var neighbor_path = astar.get_id_path(_start, neighbor_cell)
		if len(shortest_path) == 0 || len(neighbor_path) < len(shortest_path):
			shortest_path = neighbor_path
	return shortest_path

func _physics_process(_delta):
	if paused || len(path) == 0:
		return
	if debug_draw:
		queue_redraw()
	var next_point = tilemap.map_to_local(path[0])
	look_direction(next_point)
	var distance = parent.position.distance_to(next_point)
	if distance < min_distance: #- if reached point
		path.remove_at(0)
		if len(path) == 0:
			set_physics_process(false)
			parent.destination_reached()
			return
		next_point = tilemap.map_to_local(path[0])
	var dir = (next_point - parent.position).normalized()
	parent.position += dir * speed

func _draw():
	if !debug_draw || len(path) == 0:
		return
	var last = tilemap.map_to_local(path[0]) - parent.position
	for i in len(path)-1:
		var from = tilemap.map_to_local(path[i])
		var to = tilemap.map_to_local(path[i+1])
		draw_line(last, last + to - from, parent.customer.color)
		last += to - from

func look_direction(to):
	var direction = to - parent.position
	animation.walk_animation(direction)
	
func pause(seconds: float) -> void:
	paused = true
	await get_tree().create_timer(seconds).timeout
	paused = false
