extends Node

# tile selection
var is_selected = false

# as tile index
var selected : Vector2i = Vector2i.ZERO 

# map Vector2 pixel coords to unit objects
var unit_map : Dictionary

func selected_index() -> Vector2i:
	return selected

func selected_coords() -> Vector2i:
	return Coord.index_to_coord(selected)

func select_at_mouse() -> void:
	selected = Coord.get_mouse_index()
	is_selected = true

func add_unit(position: Vector2i, instance: Node) -> void:
	unit_map[position] = instance

func unit_at(position: Vector2i) -> Node:
	if has_unit(position):
		return unit_map[position]
	return null

func unit_at_selected() -> Node:
	return unit_at(selected)

func has_unit(position: Vector2i) -> bool:
	return unit_map.has(position)

func has_unit_at_selected() -> bool:
	return has_unit(selected)

# game phase
enum PHASE { PLACE, MOVE, ENEMY }
var _phase : PHASE = PHASE.PLACE
var _set_phase_callbacks : Array[Callable] = []

func set_phase(new_phase: PHASE) -> void:
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