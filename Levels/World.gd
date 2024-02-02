extends Level

var placement_chance = 0.05 #- possibly switch to number based system instead later, where a random number of ingredients gets spawned every day

func _ready():
	super()
	if !Scenes.seen_today.has(SceneManager.Scene.World):
		set_ingredient_locations()
		Scenes.seen_today.append(SceneManager.Scene.World)
	place_ingredients()
	SignalManager.connect("ingredient_picked_up", remove_from_ingredients)
	
func set_ingredient_locations():
	for cell in Helper.get_all_tiles(tilemap):
		if Data.rng.randf() <= placement_chance && !astar.is_point_solid(cell):
			Scenes.world_ingredients[cell] = Ingredients.get_random()

func place_ingredients():
	for pos in Scenes.world_ingredients:
		var ingredient = Paths.ingredient.instantiate()
		add_child(ingredient)
		ingredient.set_variables(Scenes.world_ingredients[pos], pos)
		ingredient.position = tilemap.map_to_local(pos)
		
func remove_from_ingredients(_ingredient, pos):
	Scenes.world_ingredients.erase(pos)


