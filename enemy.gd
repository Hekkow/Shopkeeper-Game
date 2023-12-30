extends CharacterBody2D
const speed = 300
@export var player: Node2D

var astar
var path
var tilemap
var collision_shape
var min_distance = 5

func _ready():
	set_physics_process(false)
	collision_shape = get_node("CollisionShape2D")


	set_path(player.position)
	set_physics_process(true)

func set_path(target):
	path = astar.get_id_path(tilemap.local_to_map(collision_shape.global_transform.origin), tilemap.local_to_map(target))
	
func _physics_process(_delta):
	SignalManager.emit_signal("path_changed", path)
	var next_point = tilemap.map_to_local(path[0])
	var pos = collision_shape.global_transform.origin
	var distance = pos.distance_to(next_point)
	if distance < min_distance:
		path.remove_at(0)
		if (len(path) == 0):
			set_physics_process(false)
			return
		next_point = tilemap.map_to_local(path[0])
	var dir = (next_point - pos).normalized()
	velocity = dir * speed
	move_and_slide()