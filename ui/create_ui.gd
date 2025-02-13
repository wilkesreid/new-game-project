extends Control

enum UNIT { CONSTELLATION, MIMI, DERPY }

func _ready() -> void:
	State.phase_any.connect(func (new_phase : State.PHASE):
		if new_phase != State.PHASE.PLACE:
			queue_free()
	)

func create_at_selected(scene_path : String) -> void:
	if State.has_at_selected():
		State.at_selected().queue_free()
	var instance = load(scene_path).instantiate()
	instance.position = State.selected_coord()
	get_tree().root.add_child(instance)

func _on_derpy_button_pressed() -> void:
	create_at_selected("res://units/derpy/derpy.tscn")

func _on_mimi_button_pressed() -> void:
	create_at_selected("res://units/mimi/mimi.tscn")	

func _on_constellation_button_pressed() -> void:
	create_at_selected("res://units/constellation/constellation.tscn")


func _on_start_button_pressed() -> void:
	State.phase = State.PHASE.MOVE
	State.retrigger_select()
