extends Control

enum UNIT { CONSTELLATION, MIMI, DERPY }

func _ready() -> void:
	State.on_set_phase(func (new_phase: State.PHASE) -> void:
		if new_phase == State.PHASE.PLACE:
			show()
		else:
			hide())

func create_at_selected(scene_path : String) -> void:
	var instance = load(scene_path).instantiate()
	instance.position = State.selected_coord()
	get_tree().root.add_child(instance)	

func _on_derpy_button_pressed() -> void:
	create_at_selected("res://units/derpy/derpy.tscn")

func _on_mimi_button_pressed() -> void:
	create_at_selected("res://units/mimi/mimi.tscn")	

func _on_constellation_button_pressed() -> void:
	create_at_selected("res://units/constellation/constellation.tscn")
