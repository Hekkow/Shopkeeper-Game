extends TileMap

class_name TileMapGenerator

var astar
var path
const ground_layer = 0
const solid_layers = [1, 2]
@export var show_cell_numbers = true
const heuristic = AStarGrid2D.HEURISTIC_CHEBYSHEV
const diagonal_mode = AStarGrid2D.DIAGONAL_MODE_NEVER

func _ready():
	SignalManager.connect("level_ready", on_level_ready)
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
			label.modulate = Color.RED
			add_child(label)
			label.position = map_to_local(cell) - label.size/2
	
	for i in solid_layers:
		for cell in get_used_cells(i):
			astar.set_point_solid(cell)

func on_level_ready(level):
	level.astar = astar
	level.tilemap = self