extends Level

func _ready():
    super()
    if !Scenes.seen_today.has(SceneManager.Scene.World):
        set_ingredient_locations()
        Scenes.seen_today.append(SceneManager.Scene.World)
    place_ingredients()
    SignalManager.connect("ingredient_picked_up", remove_from_ingredients)
    
func set_ingredient_locations():
    var rect = tilemap.get_used_rect()
    for x in range(rect.position.x, rect.position.x + rect.size.x):
        for y in range(rect.position.y, rect.position.y + rect.size.y):
            if Data.rng.randf() <= 0.05:
                Scenes.world_ingredients[Vector2i(x, y)] = Ingredients.get_random()

func place_ingredients():
    for pos in Scenes.world_ingredients:
        var ingredient = Paths.ingredient.instantiate()
        ingredient.set_variables(Scenes.world_ingredients[pos], pos)
        add_child(ingredient)
        ingredient.position = tilemap.map_to_local(pos)
        
func remove_from_ingredients(_ingredient, pos):
    Scenes.world_ingredients.erase(pos)