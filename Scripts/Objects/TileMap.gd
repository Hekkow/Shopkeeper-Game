extends TileMap

var astar
var path
var table_base_layer = 1
var display_case_layer = 2
var display_cases = {}

func _ready():
	SignalManager.connect("store_initialized", on_store_initialized)
	astar = AStarGrid2D.new()
	astar.region = Rect2i(0, 0, 18, 14)
	astar.cell_size = tile_set.tile_size
	astar.diagonal_mode = AStarGrid2D.DIAGONAL_MODE_NEVER
	astar.update()
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
