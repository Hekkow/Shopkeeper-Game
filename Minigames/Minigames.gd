extends CanvasLayer

const haggling_position = Vector2(267, 72)

func _ready():
	SignalManager.connect("haggling_started", open_haggling)


func open_haggling(customer):
	var haggling = instantiate_scene(Paths.haggling, haggling_position)
	haggling.set_customer(customer)

func instantiate_scene(scene, pos: Vector2):
	var scene_instance = scene.instantiate()
	scene_instance.position = pos
	scene_instance.z_index = 10
	add_child(scene_instance)
	return scene_instance