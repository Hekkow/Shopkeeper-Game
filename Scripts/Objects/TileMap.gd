extends TileMap

var astar
var path
const ground_layer = 0
const table_base_layer = 2
const display_case_layer = 2
const show_cell_numbers = false
var display_cases = {}

func _ready():
	SignalManager.connect("store_initialized", on_store_initialized)
	astar = AStarGrid2D.new()
	astar.region = Rect2i(4, 0, 9, 10)
	astar.cell_size = tile_set.tile_size
	astar.diagonal_mode = AStarGrid2D.DIAGONAL_MODE_NEVER
	astar.update()
	if show_cell_numbers:
		for cell in get_used_cells(ground_layer):
			var label = Label.new()
			label.text = str(cell)
			label.z_index = 100
			add_child(label)
			label.position = map_to_local(cell) - label.size/2
	for cell in get_used_cells(table_base_layer):
		astar.set_point_solid(cell)
	for cell in get_used_cells(display_case_layer):
		display_cases[cell] = null
	
	

func on_store_initialized():
	Data.store.astar = astar
	Data.store.tilemap = self
	Data.store.display_cases = display_cases



func get_collidable() -> Array:
	var collidable_tiles = []
	var layer = table_base_layer
	var cells = get_used_cells(layer)
	for cell in cells:
		collidable_tiles.append(cell)
	return collidable_tiles
