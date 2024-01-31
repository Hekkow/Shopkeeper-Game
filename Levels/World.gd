extends Level

var placement_chance = 0.05

func _ready():
    solid_layers = [1]
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
            var cell = Vector2i(x, y)
            if Data.rng.randf() <= placement_chance && !is_cell_in_solid(cell):
                Scenes.world_ingredients[cell] = Ingredients.get_random()

func place_ingredients():
    for pos in Scenes.world_ingredients:
        var ingredient = Paths.ingredient.instantiate()
        add_child(ingredient)
        ingredient.set_variables(Scenes.world_ingredients[pos], pos)
        ingredient.position = tilemap.map_to_local(pos)
        
func remove_from_ingredients(_ingredient, pos):
    Scenes.world_ingredients.erase(pos)

func is_cell_in_solid(cell):
    for solid in Scenes.solids:
        if solid.has_point(tilemap.map_to_local(cell)):
            return true
    return false