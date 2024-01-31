extends CanvasLayer

var stack = []
var in_ui = false

func _ready() -> void:
	state_changed()
	SignalManager.connect("scene_changing", state_changed)
	SignalManager.connect("item_created", close)
	SignalManager.connect("craft_button_pressed", open_craft_menu)
	SignalManager.connect("set_up_button_pressed", open_set_up_menu)
	SignalManager.connect("item_placed", open_set_up_menu)
	SignalManager.connect("item_placement_cancelled", open_set_up_menu)
	SignalManager.connect("ingredient_store_interacted", open_ingredient_store_menu)
	SignalManager.connect("craft_menu_panel_pressed", close)
	SignalManager.connect("set_up_menu_panel_pressed", close)
	SignalManager.connect("ingredient_store_panel_pressed", close)
	


func state_changed(_scene=null):
	Helper.remove_children(self)
	if SceneManager.state == SceneManager.Scene.Store:
		instantiate_scene(Paths.store_open_menus, false)

func open_craft_menu():
	instantiate_scene(Paths.craft_menu)

func open_set_up_menu(_case=null, _item=null):
	instantiate_scene(Paths.set_up_menu)
	
func open_ingredient_store_menu():
	instantiate_scene(Paths.ingredient_store_menu)

func instantiate_scene(scene, add_to_stack=true):
	var scene_instance = scene.instantiate()
	add_child(scene_instance)
	if add_to_stack:
		stack.append(scene_instance)
		in_ui = true

func close(_param1=null, _param2=null):
	if len(stack) > 0:
		stack.pop_back().queue_free()
	if len(stack) == 0:
		in_ui = false

func _input(event):
	if event.is_action_pressed("ui_cancel"):
		close()