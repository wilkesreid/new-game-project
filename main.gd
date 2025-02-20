extends Node2D

@onready var target_texture = preload("res://sprites/target.png")

var time : float
var alpha : float = 0

var navmap : NavigationServer2D

var last_mouse_index : Vector2i = Vector2i.ZERO

func _ready() -> void:
	Asg.setup(State.tilemap_layer.get_used_rect())
	for y in range(Asg.y(), Asg.yend()):
		for x in range(Asg.x(), Asg.xend()):
			Asg.set_solid(Vector2i(x, y))
	for cell in State.tilemap_layer.get_used_cells():
		if !State.has(cell):
			Asg.set_not_solid(cell)
	
	State.phase_win.connect(func ():
		$UILayer/Control/WinPanel.show()
	)

func select_at_mouse():
	if State.has_at_mouse():
		Sfx.play('SelectUnit')
	else:
		Sfx.play('Select')
	State.select_at_mouse()

func mouse_move():
	var unit = State.at_selected()
	if unit and unit is Friendly:
		var moves = unit.moves
		var path = Asg.get_id_path(State.selected, Coord.mouse_index())
		if State.tilemap_layer.has_tile_at(Coord.mouse_index()) && path.size() > 0 && path.size() <= moves:
			$Audio/Tick.play()

func _process(delta: float) -> void:
	if Input.is_action_just_pressed('quit'):
		get_tree().quit()

	if Coord.mouse_index() != last_mouse_index:
		mouse_move()
		last_mouse_index = Coord.mouse_index()

	# everything below here needs to be reorganized and redone
	if Input.is_action_just_pressed('right_click'):
		if State.doing_ability:
			State.end_ability()
		else:
			State.clear_selection()
	if Input.is_action_just_pressed("click") and is_mouse_in_grid():
		if !is_mouse_on_tile():
			State.clear_selection()
		else:
			# we clicked on a tile
			var unit = State.at_selected()
			if !State.is_phase(State.PHASE.MOVE):
				select_at_mouse()
			elif !unit or unit is not Friendly:
				select_at_mouse()
			else:
				# we're in the move phase, and we have a unit selected
				if !State.doing_ability:
					if State.has_at_mouse():
						select_at_mouse()
					else:
						# we aren't doing an ability, and we clicked on an empty tile
						var path = Asg.get_id_path(State.selected, Coord.mouse_index())
						if path.size() == 0 or path.size() > unit.moves:
							select_at_mouse()
						else:
							# we clicked on a tile we can move to
							State.clear_selection()
							for tile in path:
								unit.move_to(tile)
								await get_tree().create_timer(State.game_speed).timeout
							State.select_index(unit.index)
				else:
					# we're doing an ability
					var ability = State.current_ability
					var path = Asg.get_id_path_ignore_dest(State.selected, Coord.mouse_index())
					if path.size() > 0 and path.size() <= ability.distance:
						ability.execute(Coord.mouse_index())
						State.end_ability()
					else:
						State.end_ability()
	
	time += delta
	alpha = (sin(time*8)+1)/2
	queue_redraw()

func _draw() -> void:
	var iv = Coord.mouse_index()

	# draw white rect around tile under mouse
	if State.tilemap_layer.has_tile_at(iv):
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
				if !State.doing_ability:
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
								if State.tilemap_layer.has_tile_at(t) && path.size() > 0 && path.size() <= moves:
									draw_texture(target_texture, Coord.index_to_coord(t))
				

func is_mouse_on_tile() -> bool:
	return State.tilemap_layer.get_cell_tile_data(Coord.mouse_index()) != null

func is_mouse_in_grid() -> bool:
	return State.tilemap_layer.get_used_rect().has_point(Coord.mouse_index())
