extends Node

enum { PLACE, MOVE, ENEMY, WIN }
signal on_place
signal on_move
signal on_enemy
signal on_win
signal on_any
var _phase : int = PLACE
var phase : int:
	get:
		return _phase
	set(new_phase):
		if !can_goto_phase(new_phase):
			return # TODO: show why we can't go to the next phase
		_phase = new_phase
		match new_phase:
			PLACE:
				on_place.emit()
			MOVE:
				on_move.emit()
			ENEMY:
				on_enemy.emit()
			WIN:
				on_win.emit()
		on_any.emit(new_phase)

func is_phase(p : int) -> bool:
	return _phase == p

func can_goto_phase(p: int) -> bool:
	match p:
		PLACE:
			return true
		MOVE:
			# can't go to move phase if there are no units
			return State.map.values().any(func (unit):
				return unit is Friendly
			)
		ENEMY:
			# can't go to enemy's turn if we haven't moved all our units
			return true # TODO: return false if we haven't finished our turn
		WIN:
			return Enemies.active_enemies.size() == 0
		_:
			return false