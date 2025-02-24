extends Node

var grid = AStarGrid2D.new()

func setup() -> void:
	grid.region = Coord.grid_rect
	grid.cell_size = Coord.grid_cell
	grid.diagonal_mode = AStarGrid2D.DIAGONAL_MODE_NEVER
	grid.default_compute_heuristic = AStarGrid2D.HEURISTIC_MANHATTAN
	grid.default_estimate_heuristic = AStarGrid2D.HEURISTIC_MANHATTAN
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

# expects grid index, not pixel coord
func set_solid(v : Vector2i) -> void:
	grid.set_point_solid(v, true)

func set_not_solid(v : Vector2i) -> void:
	grid.set_point_solid(v, false)

func is_point_solid(t : Vector2i) -> bool:
	if grid.region.has_point(t):
		return grid.is_point_solid(t)
	return false

func get_id_path(from : Vector2i, to : Vector2i) -> Array[Vector2i]:
	if grid.region.has_point(from) && grid.region.has_point(to):
		var path = grid.get_id_path(from, to)
		path.pop_front()
		return path
	return []

func get_id_path_ignore_dest(from : Vector2i, to : Vector2i) -> Array[Vector2i]:
	var to_solid = is_point_solid(to)
	if to_solid:
		set_not_solid(to)
	var path = get_id_path(from, to)
	if to_solid:
		set_solid(to)
	return path

