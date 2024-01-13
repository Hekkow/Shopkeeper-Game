extends TileMap

var astar
var path
const ground_layer = 0
const display_case_layer = 1
const solid_layers = [1, 2, 3]
@export var show_cell_numbers = true
# const heuristic = AStarGrid2D.HEURISTIC_EUCLIDEAN
# const heuristic = AStarGrid2D.HEURISTIC_MANHATTAN
# const heuristic = AStarGrid2D.HEURISTIC_OCTILE
const heuristic = AStarGrid2D.HEURISTIC_CHEBYSHEV
const diagonal_mode = AStarGrid2D.DIAGONAL_MODE_NEVER


var display_cases = {}

func _ready():
	SignalManager.connect("store_initialized", on_store_initialized)
	astar = AStarGrid2D.new()
	astar.region = get_used_rect()
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
	
	for i in solid_layers:
		for cell in get_used_cells(i):
			astar.set_point_solid(cell)

	for cell in get_used_cells(display_case_layer):
		display_cases[cell] = DisplayCase.new()
		
func on_store_initialized():
	Data.store.astar = astar
	Data.store.tilemap = self
	Data.store.display_cases = display_cases
