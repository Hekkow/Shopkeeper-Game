extends TileMap

var astar
var path
const grid_size = Rect2i(4, 0, 9, 10)
const ground_layer = 0
const display_case_layer = 1
const show_cell_numbers = false
# const heuristic = AStarGrid2D.HEURISTIC_EUCLIDEAN
# const heuristic = AStarGrid2D.HEURISTIC_MANHATTAN
# const heuristic = AStarGrid2D.HEURISTIC_OCTILE
const heuristic = AStarGrid2D.HEURISTIC_CHEBYSHEV
const diagonal_mode = AStarGrid2D.DIAGONAL_MODE_NEVER


var display_cases = {}

func _ready():
	SignalManager.connect("store_initialized", on_store_initialized)
	astar = AStarGrid2D.new()
	astar.region = grid_size
	astar.cell_size = tile_set.tile_size
	astar.diagonal_mode = diagonal_mode
	astar.default_compute_heuristic = heuristic
	astar.default_estimate_heuristic = heuristic
	astar.update()
	if show_cell_numbers:
		for cell in get_used_cells(ground_layer):
			var label = Label.new()
			label.text = str(cell)
			label.z_index = 100
			add_child(label)
			label.position = map_to_local(cell) - label.size/2
	for cell in get_used_cells(display_case_layer):
		astar.set_point_solid(cell)
		display_cases[cell] = null
func on_store_initialized():
	Data.store.astar = astar
	Data.store.tilemap = self
	Data.store.display_cases = display_cases
