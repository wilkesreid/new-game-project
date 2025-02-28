extends Node2D

@onready var target_texture = preload("res://sprites/target.png")
var store_scene = preload("res://store.tscn")

var time : float
var alpha : float = 0

var navmap : NavigationServer2D

var last_mouse_index : Vector2i = Vector2i.ZERO

func _ready() -> void:
	# generate map
	Asg.setup()
	var noise = FastNoiseLite.new()
	noise.seed = randi()
	noise.frequency = .1
	for y in range(Coord.grid_rect.size.y):
		for x in range(Coord.grid_rect.size.x):
			var val = noise.get_noise_2d(x, y)
			if val > -.3:
				State.tilemap_layer.set_cell(Vector2i(x, y), 0, Vector2i(0, 0))
				Asg.set_not_solid(Vector2i(x, y))
			else:
				pass
				Asg.set_solid(Vector2i(x, y))

	# generate enemy units in top-left quadrant
	var center = Coord.grid_rect.get_center()
	var enemies_to_create = 2
	for i in range(enemies_to_create):
		var x = -1
		var y = -1
		while State.tilemap_layer.get_cell_tile_data(Vector2i(x, y)) == null:
			x = randi() % center.x
			y = randi() % center.y
		var enemy_stats = Enemies.enemies.values()[randi() % Enemies.enemies.size()]
		Enemy.create(Vector2i(x, y), enemy_stats)

	State.phase_win.connect(on_win)

func on_win():
	$UILayer/Control/WinPanel.show()
	await get_tree().create_timer(2).timeout
	get_tree().root.add_child(store_scene)


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
			Sfx.play('Tick')

func _unhandled_input(event : InputEvent):
	if event.is_action_pressed("click") and is_mouse_in_grid():
		if !is_mouse_on_tile():
			State.clear_selection()
		else:
			# we clicked on a tile
			var unit = State.at_selected()
			var path = Asg.get_id_path(State.selected, Coord.mouse_index())
			if (
				!State.is_phase(State.PHASE.MOVE)
				or !unit
				or unit is not Friendly
				or (!State.doing_ability and (
					State.has_at_mouse()
					or path.size() == 0
					or path.size() > unit.moves
				))
			):
				select_at_mouse()
				return
			# we're in the move phase, and we have a unit selected
			if !State.doing_ability:
				# we clicked on a tile we can move to
				State.clear_selection()
				for tile in path:
					unit.move_to(tile)
					await get_tree().create_timer(State.game_speed).timeout
				State.select_index(unit.index)
			else:
				if State.ability_unit is Enemy:
					return
				# we're doing an ability
				var ability = State.current_ability
				var p = Asg.get_id_path_ignore_dest(State.selected, Coord.mouse_index())
				if p.size() > 0 and p.size() <= ability.distance:
					ability.execute(Coord.mouse_index())
				else:
					State.end_ability()

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
	
	time += delta
	alpha = (sin(time*8)+1)/2
	queue_redraw()

func _draw() -> void:
	# if any tile is selected
	if State.is_selected:
		
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
