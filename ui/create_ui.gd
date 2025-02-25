extends Control

enum UNIT { CONSTELLATION, MIMI, DERPY }

func _ready() -> void:
	State.phase_any.connect(func (new_phase : State.PHASE):
		if new_phase != State.PHASE.PLACE:
			queue_free()
	)

func create_at_selected(scene_path : String) -> void:
	if !State.is_selected:
		return
	$Audio/Click.play()
	if State.has_at_selected():
		State.at_selected().queue_free()
	var instance = load(scene_path).instantiate()
	instance.position = State.selected_coord()
	State.units_container.add_child(instance)

func _on_derpy_button_pressed() -> void:
	create_at_selected("res://units/derpy/derpy.tscn")

func _on_mimi_button_pressed() -> void:
	create_at_selected("res://units/mimi/mimi.tscn")	

func _on_constellation_button_pressed() -> void:
	create_at_selected("res://units/constellation/constellation.tscn")

func _on_knife_button_pressed():
	create_at_selected("res://units/knife/knife.tscn")

func _on_razor_button_pressed():
	create_at_selected("res://units/level2/razor/razor.tscn")

func _on_start_button_pressed() -> void:
	State.phase = State.PHASE.MOVE
	State.retrigger_select()

func _on_button_mouse_entered():
	$Audio/Hover.play()
