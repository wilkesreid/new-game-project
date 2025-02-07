extends Control

enum UNIT { CONSTELLATION, MIMI, DERPY }

func _ready() -> void:
	State.on_set_phase(func (new_phase: State.PHASE) -> void:
		if new_phase == State.PHASE.PLACE:
			show()
		else:
			hide())

func create(Unit : PackedScene) -> void:
	if State.is_selected:
		if State.has_unit_at_selected():
			var existing = State.unit_at_selected()
			get_tree().root.remove_child(existing)
		var instance = Unit.instantiate()
		instance.set_position(State.selected)
		get_tree().root.add_child(instance)	
		State.add_unit(State.selected, instance)


func _on_derpy_button_pressed() -> void:
	var Unit = load("res://units/derpy/derpy.tscn")
	create(Unit)


func _on_mimi_button_pressed() -> void:
	var Unit = load("res://units/mimi/mimi.tscn")
	create(Unit)

func _on_constellation_button_pressed() -> void:
	var Unit = load("res://units/constellation/constellation.tscn")
	create(Unit)
