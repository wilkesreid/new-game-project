extends Node2D

@onready var target_texture = preload("res://sprites/target.png")

var time : float
var alpha : float = 0

var navmap : NavigationServer2D

func _ready() -> void:
	Asg.setup($TileMapLayer.get_used_rect())
	for y in range(Asg.y(), Asg.yend()):
		for x in range(Asg.x(), Asg.xend()):
			Asg.set_solid(Vector2i(x, y))
	for cell in $TileMapLayer.get_used_cells():
		if !State.has(cell):
			Asg.set_not_solid(cell)

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("click") && is_mouse_in_grid():
		if is_mouse_on_tile():

			# If we're in the move phase, and a unit is already selected,
			# and we didn't just click on a different unit
			var unit = State.at_selected()
			if (
				State.is_phase(State.PHASE.MOVE)
				and unit
				and unit is Unit
				and unit is not Enemy
				and !Asg.is_point_solid(Coord.mouse_index())
				and !State.has_at_mouse()
			):
				var path = Asg.get_id_path(State.selected, Coord.mouse_index())
				# move the selected unit if we can
				if path.size() <= unit.speed:
					State.clear_selection()
					for tile in path:
						unit.move_to(tile)
						await get_tree().create_timer(.1).timeout
					State.select_index(unit.index)
				else:
					State.select_at_mouse()
			else:
				State.select_at_mouse()
		else:
			State.clear_selection()
	
	# TODO: Make this more manageable and stable
	if Input.is_action_just_pressed("next"):
		if State.is_phase(State.PHASE.PLACE):
			State.set_phase(State.PHASE.MOVE)
		elif State.is_phase(State.PHASE.MOVE):
			State.set_phase(State.PHASE.ENEMY)
		elif State.is_phase(State.PHASE.ENEMY):
			State.set_phase(State.PHASE.MOVE)
	time += delta
	alpha = (sin(time*8)+1)/2
	queue_redraw()

func _draw() -> void:
	var iv = Coord.mouse_index()

	# draw white rect around tile under mouse
	if $TileMapLayer.has_tile_at(iv):
		draw_rect(Rect2(Coord.index_to_coord(iv), Coord.grid_cell), Color(1, 1, 1, alpha), false, 2)
	
	# if any tile is selected
	if State.is_selected:
		# draw flashing blue rect around selected tile
		draw_rect(Rect2(State.selected_coord(), Coord.grid_cell), Color(0, 1, 1, alpha), false, 2)
		
		# if a unit is at the selected tile
		var unit = State.at_selected()
		if unit and unit is Unit:
			var speed = unit.speed
			var moves = unit.moves

			if State.is_phase(State.PHASE.MOVE):
				# draw red path from unit to mouse
				if (
					unit is not Enemy and
					!Asg.is_point_solid(Coord.mouse_index()) and
					!State.has_at_mouse()
				):
					var p = Asg.get_id_path(State.selected, Coord.mouse_index())
					if p.size() <= moves:
						for i in p:
							draw_rect(Rect2(Coord.index_to_coord(i), Coord.grid_cell), Color(1, 0, 0, .5), true)

				# draw indicators for where unit can move
				for x in range(-1 * speed, speed + 1):
					for y in range(-1 * speed, speed + 1):
						var t = State.selected + Vector2i(x, y)
						if !Asg.is_point_solid(t):
							var path = Asg.get_id_path(State.selected, t)
							var ti = State.selected + Vector2i(x, y)
							if $TileMapLayer.has_tile_at(ti) && path.size() > 0 && path.size() <= moves:
								draw_texture(target_texture, Coord.index_to_coord(ti))

func is_mouse_on_tile() -> bool:
	return $TileMapLayer.get_cell_tile_data(Coord.mouse_index()) != null

func is_mouse_in_grid() -> bool:
	return $TileMapLayer.get_used_rect().has_point(Coord.mouse_index())
