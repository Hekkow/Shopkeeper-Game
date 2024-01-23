"""

Opens menus

"""

extends CanvasLayer

func _ready() -> void:
	SignalManager.connect("recipe_pressed", on_recipe_pressed)
	SignalManager.connect("ingredient_to_recipe_menu_opened", on_ingredient_to_recipe_menu_opened)
	SignalManager.connect("recipe_to_item_menu_opened", open_recipe_to_item_menu)
	SignalManager.connect("pot_done", open_recipe_to_item_menu)

func on_recipe_pressed(recipe: Recipe) -> void:
	instantiate_scene(Paths.price_modal)
	SignalManager.emit_signal("price_modal_spawned", recipe)

func on_ingredient_to_recipe_menu_opened() -> void:
	instantiate_scene(Paths.recipe_creation_menu)

func open_recipe_to_item_menu() -> void:
	instantiate_scene(Paths.item_creation_menu)	

func instantiate_scene(scene):
	var scene_instance = scene.instantiate()
	add_child(scene_instance)
