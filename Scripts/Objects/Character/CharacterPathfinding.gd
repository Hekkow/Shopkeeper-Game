extends Node2D

class_name CharacterPathfinding

@onready var collision_shape = get_node("../Area2D/CollisionShape2D")
var store
var tilemap
var astar
@onready var parent = get_parent()
@onready var shopping = get_node("../Shopping")
@export var paused := false
@export var debug_draw = true
var exit = Vector2(11, 10)
@export var path: Array

var min_distance := 3
var speed := 3

func _ready():
	if GameState.state == GameState.State.Shopping:
		store = Data.store
		tilemap = Data.store.tilemap
		astar = Data.store.astar
		parent.position = tilemap.map_to_local(exit) - collision_shape.global_transform.origin

func go_to(state, item=null):
	if GameState.state == GameState.State.Shopping:
		if state == shopping.State.LOOKING:
			set_destination_path(tilemap.local_to_map(store.get_corresponding_case(item).position))
		elif state == shopping.State.LINE:
			set_destination_path(store.table.get_place(parent))
		elif state == shopping.State.LEAVING:
			set_destination_path(exit)


func set_destination_path(destination: Vector2):
	if path && collision_shape.global_transform.origin.distance_to(tilemap.map_to_local(path[0])) > min_distance:
		path = get_shortest_path(path[0], destination)
	else:
		path = get_shortest_path(tilemap.local_to_map(collision_shape.global_transform.origin), destination)
	set_physics_process(true)

func get_shortest_path(_start: Vector2, destination: Vector2) -> Array:
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
	var pos = collision_shape.global_transform.origin
	look_direction(next_point)
	var distance = pos.distance_to(next_point)
	if distance < min_distance: #- if reached point
		path.remove_at(0)
		if len(path) == 0:
			set_physics_process(false)
			parent.destination_reached()
			return
		next_point = tilemap.map_to_local(path[0])
	var dir = (next_point - pos).normalized()
	parent.position += dir * speed

func _draw():
	if !debug_draw || len(path) == 0:
		return
	var last = tilemap.map_to_local(path[0]) - position
	for i in len(path)-1:
		var from = tilemap.map_to_local(path[i])
		var to = tilemap.map_to_local(path[i+1])
		draw_line(last, last + to - from, parent.customer.color)
		last += to - from

func look_direction(to):
	var direction = to - collision_shape.global_transform.origin
	parent.walk_animation(Helper.cardinal_direction(direction))
	
func pause(seconds: float) -> void:
	paused = true
	await get_tree().create_timer(seconds).timeout
	paused = false
