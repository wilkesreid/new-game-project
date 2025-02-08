extends Control

enum UNIT { CONSTELLATION, MIMI, DERPY }

func _ready() -> void:
	State.on_set_phase(func (new_phase: State.PHASE) -> void:
		if new_phase == State.PHASE.PLACE:
			show()
		else:
			hide())

func _on_derpy_button_pressed() -> void:
	var Unit = load("res://units/derpy/derpy.tscn")
	if State.is_selected:
		State.create_unit_at_selected(Unit)

func _on_mimi_button_pressed() -> void:
	var Unit = load("res://units/mimi/mimi.tscn")
	if State.is_selected:
		State.create_unit_at_selected(Unit)

func _on_constellation_button_pressed() -> void:
	var Unit = load("res://units/constellation/constellation.tscn")
	if State.is_selected:
		State.create_unit_at_selected(Unit)
