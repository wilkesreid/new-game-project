extends Node2D

# coord = pixel coordinates (e.g. x: 64, y: 64)
# index = index of tile with each tile being 1 (e.g. x: 1, y: 1)

var grid_size : int = 32
var grid_cell = Vector2i(grid_size, grid_size)

func index_to_coord(i : Vector2i) -> Vector2i:
	return i * grid_size

func coord_to_index(v : Vector2i) -> Vector2i:
	return floor(Vector2(v.x, v.y) / grid_size)

func get_mouse_index() -> Vector2i:
	return coord_to_index(get_global_mouse_position())

# does not return the exact pixel coordinate
# of the mouse; instead, returns the tile
# grid aligned coords, always a multiple of the
# grid cell size
func get_mouse_coord() -> Vector2i:
	return index_to_coord(get_mouse_index())