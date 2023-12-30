extends Node2D

var astar
var tilemap
var path
func _ready():
	SignalManager.connect("store_initialized", on_store_initialized)

func on_store_initialized():
	print("HERE1")
	tilemap = get_node("../TileMap")
	astar = AStarGrid2D.new()
	astar.region = Rect2i(0, 0, 18, 14)
	astar.cell_size = tilemap.tile_set.tile_size
	astar.diagonal_mode = AStarGrid2D.DIAGONAL_MODE_NEVER
	astar.update()
	
	for i in get_collidable():
		astar.set_point_solid(i)
		
	SignalManager.emit_signal("astar_ready", astar, tilemap)
	# SignalManager.connect("path_changed", on_path_changed)



func get_collidable() -> Array:
	var collidable_tiles = []
	var layer = 1
	var cells = tilemap.get_used_cells(layer)
	for cell in cells:
		var cell_data = tilemap.get_cell_tile_data(layer, cell)
		if cell_data.get_collision_polygons_count(0) > 0:
			collidable_tiles.append(cell)
	return collidable_tiles

# func on_path_changed(_path):
# 	path = _path
# 	queue_redraw()

# func _draw():
# 	for i in len(path)-1:
# 		var from = tilemap.map_to_local(path[i])
# 		var to = tilemap.map_to_local(path[i+1])
# 		draw_line(from, to, Color.RED)
