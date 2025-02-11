extends Control

enum UNIT { CONSTELLATION, MIMI, DERPY }

func _ready() -> void:
	State.on_set_phase(func (new_phase: State.PHASE) -> void:
		if new_phase == State.PHASE.PLACE:
			show()
		else:
			hide())

func _on_derpy_button_pressed() -> void:
	var unit = Derpy.new()
	if State.is_selected:
		State.add_at_selected(unit)

func _on_mimi_button_pressed() -> void:
	var unit = Mimi.new()
	if State.is_selected:
		State.add_at_selected(unit)

func _on_constellation_button_pressed() -> void:
	var unit = Constellation.new()
	if State.is_selected:
		State.add_at_selected(unit)
