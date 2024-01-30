extends Node2D

var dragging = false
var max_case_distance = 70
var item = null
var item_offset = Vector2(0, -80)
var closest_case_mouse_offset = Vector2(0, -50)
const display_case_layer = 1
var previous_case = null
signal on_mouse_event

func _ready():
	connect("on_mouse_event", item_clicked)
	set_process_unhandled_input(false)
	SignalManager.connect("store_opened", on_store_opened)
	SignalManager.connect("item_spawned", on_item_spawned)

func on_item_spawned(_item):
	dragging = true
	item = _item
	set_process_unhandled_input(true)

func on_store_opened():
	set_process_unhandled_input(false)

func find_closest_case(empty=false):
	var smallest_distance = 100000
	var closest_case
	var mouse_pos = get_viewport().get_mouse_position()
	for case in Data.store.display_cases:
		if empty && case.item == null:
			continue
		var d = distance(mouse_pos, case)
		if d < smallest_distance:
			smallest_distance = d
			closest_case = case
	if distance(mouse_pos, closest_case) > max_case_distance:
		return null
	return closest_case

func _process(_delta):
	if dragging:
		item.position = get_viewport().get_mouse_position()
		var case = find_closest_case()
		if case == null:
			if previous_case == null:
				return
			set_case_alternative(previous_case, false)
			previous_case = null
			return
		if case != previous_case:
			if previous_case != null:
				set_case_alternative(previous_case, false)
			set_case_alternative(case, true)
			previous_case = case

func set_case_alternative(case, alternative):
	if alternative:
		case.get_node("Sprite2D").texture = Paths.display_case_hover_texture
	else:
		case.get_node("Sprite2D").texture = Paths.display_case_texture

func _unhandled_input(event):
	if event is InputEventMouseButton && event.pressed:
		if event.button_index == MOUSE_BUTTON_LEFT:
			emit_signal("on_mouse_event")
		elif event.button_index == MOUSE_BUTTON_RIGHT:
			cancel_drag()
	elif event.is_action_pressed("ui_cancel"):
		if dragging:
			cancel_drag()

func distance(mouse, case):
	var pos = case.position + closest_case_mouse_offset
	return sqrt((mouse.x - pos.x)**2 + (mouse.y - pos.y)**2)

func cancel_drag():
	dragging = false
	Helper.remove(Items.store, item)
	item.queue_free()

func item_clicked():
	var case = find_closest_case(!dragging)
	if case == null:
		return
	
	if !dragging:
		if case.item == null:
			return
		dragging = true
		item = case.item
		SignalManager.emit_signal("item_picked_up", case, item)
		case.item = null
	else:
		if case.item != null:
			return
		set_case_alternative(previous_case, false)
		dragging = false
		item.position = case.position + item_offset
		case.item = item
		SignalManager.emit_signal("item_placed", case, item)
		item = null
	
