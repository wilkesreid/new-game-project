extends Node2D

@onready var target_texture = preload("res://sprites/target.png")
@onready var up_arrow_texture = preload("res://ui/up_arrow.png")
@onready var down_arrow_texture = preload("res://ui/down_arrow.png")
@onready var left_arrow_texture = preload("res://ui/left_arrow.png")
@onready var right_arrow_texture = preload("res://ui/right_arrow.png")

var time : float
var alpha : float = 0

var asg = AStarGrid2D.new()
var navmap : NavigationServer2D

func _ready() -> void:
	# asg.region = Rect2i(0, 0, 17, 10)
	asg.region = $TileMapLayer.get_used_rect()
	asg.cell_size = Coord.grid_cell
	asg.diagonal_mode = AStarGrid2D.DIAGONAL_MODE_NEVER
	asg.default_compute_heuristic = AStarGrid2D.HEURISTIC_MANHATTAN
	asg.update()
	for y in range(asg.region.position.y, asg.region.end.y):
		for x in range(asg.region.position.x, asg.region.end.x):
			asg.set_point_solid(Vector2i(x, y), true)
	for cell in $TileMapLayer.get_used_cells():
		asg.set_point_solid(cell, false)

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("click") && is_mouse_in_grid():
		if is_mouse_on_tile():
			State.select_at_mouse()
		else:
			State.clear_selection()

	if Input.is_action_just_pressed("next"):
		State.set_phase(State.PHASE.MOVE)
	time += delta
	alpha = (sin(time*8)+1)/2
	queue_redraw()

func _draw() -> void:
	var iv = Coord.mouse_index()

	# draw white rect around tile under mouse
	if $TileMapLayer.has_tile_at(iv):
		draw_rect(Rect2(Coord.index_to_coord(iv), Coord.grid_cell), Color(1, 1, 1, alpha), false, 2)

	if State.is_selected:
		# draw flashing blue rect around selected tile
		draw_rect(Rect2(State.selected_coords(), Coord.grid_cell), Color(0, 1, 1, alpha), false, 2)
		
		# if a unit is selected
		if State.has_unit_at_selected():
			var unit = State.unit_at_selected()
			var speed = unit.speed
			if State.get_phase() == State.PHASE.MOVE:
				draw_movement_arrows(State.selected_index())

			# draw red path from unit to mouse
			if $TileMapLayer.has_tile_at(Coord.mouse_index()):
				var p = asg.get_id_path(Coord.mouse_index(), State.selected_index())
				if p.size() <= speed + 1:
					for i in p:
						draw_rect(Rect2(Coord.index_to_coord(i), Coord.grid_cell), Color(1, 0, 0, .5), true)

			# draw indicators for where unit can move
			for x in range(-1 * speed, speed + 1):
				for y in range(-1 * speed, speed + 1):
					var t = State.selected_index() + Vector2i(x, y)
					if $TileMapLayer.has_tile_at(t):
						var path = asg.get_id_path(State.selected_index(), t)
						var ti = State.selected_index() + Vector2i(x, y)
						if $TileMapLayer.has_tile_at(ti) && path.size() <= speed + 1:
							draw_texture(target_texture, Coord.index_to_coord(ti))

func is_mouse_on_tile() -> bool:
	return $TileMapLayer.get_cell_tile_data(Coord.mouse_index()) != null

func is_mouse_in_grid() -> bool:
	return $TileMapLayer.get_used_rect().has_point(Coord.mouse_index())

func draw_movement_arrows(index : Vector2i) -> void:
	var up_neighbor = index + Vector2i(0, -1)
	var up_neighbor_coord = Coord.index_to_coord(up_neighbor)
	var up_arrow_alpha = 1. if Coord.mouse_index() == up_neighbor else .6
	draw_texture_rect(up_arrow_texture, Rect2i(up_neighbor_coord, Coord.grid_cell), false, Color(1, 1, 1, up_arrow_alpha))

	draw_texture_rect(down_arrow_texture, Rect2i(Coord.index_to_coord(State.selected_index() + Vector2i(0, 1)), Coord.grid_cell), false, Color(1, 1, 1, 1. if Coord.mouse_index() == State.selected_index() + Vector2i(0, 1) else .6))
	draw_texture_rect(left_arrow_texture, Rect2i(Coord.index_to_coord(State.selected_index() + Vector2i(-1, 0)), Coord.grid_cell), false, Color(1, 1, 1, 1. if Coord.mouse_index() == State.selected_index() + Vector2i(-1, 0) else .6))
	draw_texture_rect(right_arrow_texture, Rect2i(Coord.index_to_coord(State.selected_index() + Vector2i(1, 0)), Coord.grid_cell), false, Color(1, 1, 1, 1. if Coord.mouse_index() == State.selected_index() + Vector2i(1, 0) else .6))