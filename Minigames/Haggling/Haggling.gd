extends Control

const speed = 10
const score_multiplier_hit = 1.3
const score_multiplier_missed = 1.2

const minimum_distance = 5
const number_boxes = 6
const box_size = 20
const pointer_size = 3

@onready var pointer = $Pointer
var pointer_direction = Vector2(1, 0)
var boxes = []
var background
var colors = [Color.RED, Color.GREEN, Color.BLUE, Color.ORANGE]
var customer

const pointer_color = Color.RED
const box_color = Color.GREEN
const background_color = Color.WHITE
const missed_color = Color.RED
const missed_duration = 0.05




@onready var box_height = size.y
var score_multiplier = 1

func _ready():
	background = ColorRect.new()
	background.size = size
	background.color = background_color
	add_child(background)
	for i in number_boxes:
		boxes.append(create_area(Vector2(get_valid_position(), 0), Vector2(box_size, box_height), box_color))
	
func set_customer(_customer):
	customer = _customer

func get_valid_position():
	var found = false
	var x
	while !found:
		x = Data.rng.randi_range(0, size.x - box_size)
		found = true
		for box in boxes:
			var left_boundary_old = box.position.x
			var right_boundary_old = box.position.x + box_size
			var left_boundary_new = x
			var right_boundary_new = x + box_size
			if right_boundary_old >= left_boundary_new && left_boundary_old <= right_boundary_new:
				found = false
				break
			if abs(left_boundary_old - right_boundary_new) < minimum_distance:
				found = false
				break
			if abs(right_boundary_old - left_boundary_new) < minimum_distance:
				found = false
				break
	return x

func create_area(_position: Vector2, _size: Vector2, _color: Color, _z_index: int = 0):
	var area = Area2D.new()
	var collision = CollisionShape2D.new()
	var r = RectangleShape2D.new()
	var color_rect = ColorRect.new()
	area.position = _position
	area.z_index = _z_index
	r.size = _size
	collision.shape = r
	collision.position = _size/2
	color_rect.size = _size
	color_rect.color = _color
	area.add_child(collision)
	area.add_child(color_rect)
	add_child(area)
	return area

func _input(event):
	if event is InputEventMouseButton && event.pressed:
		var overlap = pointer.get_overlapping_areas()
		if len(overlap) > 0:
			hit(overlap[0])
		else:
			missed()

func hit(box):
	box.queue_free()
	score_multiplier *= score_multiplier_hit
func missed():
	score_multiplier /= score_multiplier_missed
	background.color = missed_color
	await get_tree().create_timer(missed_duration).timeout
	background.color = background_color


func _process(_delta):
	pointer.position += pointer_direction * speed
	if pointer.position.x >= size.x:
		pointer_direction *= -1
	if pointer.position.x <= 0:
		get_tree().call_group("customers", "haggling_resume")
		SignalManager.emit_signal("haggling_ended", customer, score_multiplier)
		queue_free()