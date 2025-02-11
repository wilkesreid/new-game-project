extends Node

# tile selection
var is_selected = false

# as tile index
var selected : Vector2i = Vector2i.ZERO 

# map tile index to unit objects
var unit_map : Dictionary

## Selection

func selected_index() -> Vector2i:
	return selected

func selected_coords() -> Vector2i:
	return Coord.index_to_coord(selected)

func select_at_mouse() -> void:
	selected = Coord.mouse_index()
	is_selected = true

func select_index(index: Vector2i) -> void:
	selected = index
	is_selected = true

func select_coord(coord: Vector2i) -> void:
	selected = Coord.coord_to_index(coord)
	is_selected = true

func clear_selection() -> void:
	selected = Vector2i.ZERO
	is_selected = false

## unit Map

func create_unit_at_index(rs : Resource, index : Vector2i) -> void:
	remove_unit(index)
	var instance = rs.instantiate()
	instance.set_position(Coord.index_to_coord(index))
	add_unit(index, instance)

func create_unit_at_selected(rs : Resource) -> void:
	create_unit_at_index(rs, selected)

func add_unit(position: Vector2i, instance: Unit) -> void:
	get_tree().root.add_child(instance)
	add_existing_unit(position, instance)

func add_existing_unit(position: Vector2i, instance: Unit) -> void:
	unit_map[position] = instance
	Asg.set_solid(position)

func unit_at(position: Vector2i) -> Node2D:
	if has_unit(position):
		return unit_map[position]
	return null

func unit_at_selected() -> Node2D:
	return unit_at(selected)

func has_unit_at_mouse() -> bool:
	return has_unit(Coord.mouse_index())

func has_unit(position: Vector2i) -> bool:
	return unit_map.has(position)

func has_unit_at_selected() -> bool:
	return has_unit(selected)

func remove_unit(position: Vector2i) -> void:
	if has_unit(position):
		var instance = unit_at(position)
		get_tree().root.remove_child(instance)
		unit_map.erase(position)
		Asg.set_not_solid(position)

# doesn't actually move the unit,
# just updates the map
func unit_move_index(from : Vector2i, to : Vector2i) -> void:
	var unit = unit_at(from)
	unit_map.erase(from)
	unit_map[to] = unit
	Asg.set_not_solid(from)
	Asg.set_solid(to)

# also doesn't move the unit physically,
# just updates the map
func unit_move_coord(from : Vector2i, to : Vector2i) -> void:
	var from_index = Coord.coord_to_index(from)
	var to_index = Coord.coord_to_index(to)
	unit_move_index(from_index, to_index)

## Game Phase

enum PHASE { PLACE, MOVE, ENEMY }
var _phase : PHASE = PHASE.PLACE
# var _phase = PHASE.MOVE # debugging, skip to move phase
var _set_phase_callbacks : Array[Callable] = []

func get_phase() -> PHASE:
	return _phase

func is_phase(phase: PHASE) -> bool:
	return _phase == phase

func set_phase(new_phase: PHASE) -> void:
	print('set phase to ', new_phase)
	if !can_goto_phase(new_phase):
		return # TODO: show why we can't go to the next phase
	_phase = new_phase
	for callable in _set_phase_callbacks:
		callable.call(new_phase)
	
func can_goto_phase(phase: PHASE) -> bool:
	match phase:
		PHASE.PLACE:
			return true
		PHASE.MOVE:
			# can't go to move phase if there are no units
			return !unit_map.is_empty()
		PHASE.ENEMY:
			# can't go to enemy's turn if we haven't moved all our units
			return true # TODO: return false if we haven't finished our turn
		_:
			return false

func on_set_phase(callable: Callable) -> void:
	_set_phase_callbacks.append(callable)
