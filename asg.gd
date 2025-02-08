extends Node

var grid = AStarGrid2D.new()

func setup(rect : Rect2i) -> void:
	grid.region = rect
	grid.cell_size = Coord.grid_cell
	grid.diagonal_mode = AStarGrid2D.DIAGONAL_MODE_NEVER
	grid.default_compute_heuristic = AStarGrid2D.HEURISTIC_MANHATTAN
	grid.update()

func x() -> int:
	return grid.region.position.x
func y() -> int:
	return grid.region.position.y
func w() -> int:
	return grid.region.size.x
func h() -> int:
	return grid.region.size.y
func xend() -> int:
	return grid.region.end.x
func yend() -> int:
	return grid.region.end.y

func set_solid(v : Vector2i) -> void:
	grid.set_point_solid(v, true)

func set_not_solid(v : Vector2i) -> void:
	grid.set_point_solid(v, false)

func is_point_solid(t : Vector2i) -> bool:
	return grid.is_point_solid(t)

func get_id_path(from : Vector2i, to : Vector2i) -> Array[Vector2i]:
	return grid.get_id_path(from, to)

