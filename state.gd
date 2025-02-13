extends Node

# tile selection
var is_selected = false

# as tile index
var _selected : Vector2i = Vector2i.ZERO
var selected : Vector2i:
	get:
		return _selected
	set(value):
		_selected = value
		if value == Vector2i.ZERO:
			is_selected = false
			deselect.emit()
		else:
			is_selected = true
			select.emit(value)

signal select(index)
signal deselect

var map : Dictionary

## Selection

func selected_coord() -> Vector2i:
	return Coord.index_to_coord(selected)

func select_at_mouse() -> void:
	selected = Coord.mouse_index()

func select_index(index: Vector2i) -> void:
	selected = index

func select_coord(coord: Vector2i) -> void:
	selected = Coord.coord_to_index(coord)

func clear_selection() -> void:
	selected = Vector2i.ZERO

func retrigger_select() -> void:
	if is_selected:
		select_index(selected)

## Things on the grid

func add(pos : Vector2i, thing : Placeable):
	remove(pos)
	thing.index = pos
	map[pos] = thing
	Asg.set_solid(pos)
	if !thing.is_inside_tree():
		get_tree().root.add_child(thing)

func remove(pos : Vector2i):
	if has(pos):
		map.erase(pos)
		Asg.set_not_solid(pos)

func at(pos : Vector2i) -> Placeable:
	if has(pos):
		return map[pos]
	return null

func has(pos : Vector2i) -> bool:
	return map.has(pos)

func at_selected() -> Unit:
	return at(selected)

func has_at_selected() -> bool:
	return has(selected)

func add_at_selected(unit : Placeable) -> void:
	add(selected, unit)

func has_at_mouse() -> bool:
	return has(Coord.mouse_index())

func move(from : Vector2i, to : Vector2i) -> void:
	var thing = at(from)
	remove(from)
	remove(to)
	add(to, thing)

## Game Phase

enum PHASE { PLACE, MOVE, ENEMY }
signal phase_change(new_phase)
var _phase : PHASE = PHASE.PLACE
var phase : PHASE:
	get:
		return _phase
	set(new_phase):
		if !can_goto_phase(new_phase):
			return # TODO: show why we can't go to the next phase
		_phase = new_phase
		phase_change.emit(new_phase)

func is_phase(p: PHASE) -> bool:
	return _phase == p

func can_goto_phase(p: PHASE) -> bool:
	match p:
		PHASE.PLACE:
			return true
		PHASE.MOVE:
			# can't go to move phase if there are no units
			return map.values().any(func (unit):
				return unit is Friendly
			)
		PHASE.ENEMY:
			# can't go to enemy's turn if we haven't moved all our units
			return true # TODO: return false if we haven't finished our turn
		_:
			return false
