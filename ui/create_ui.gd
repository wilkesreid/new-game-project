extends Control

enum UNIT { CONSTELLATION, MIMI, DERPY }

func _ready() -> void:
	State.phase_any.connect(func (new_phase : State.PHASE):
		if new_phase != State.PHASE.PLACE:
			queue_free()
	)

func create_at_selected(key : String) -> void:
	if !State.is_selected:
		return
	$Audio/Click.play()
	if State.has_at_selected():
		State.at_selected().queue_free()
	Friendly.create(State.selected, key)
	State.retrigger_select()

func _on_knife_button_pressed():
	create_at_selected('Knife')

func _on_razor_button_pressed():
	create_at_selected('Razor')

func _on_start_button_pressed() -> void:
	State.phase = State.PHASE.MOVE
	State.retrigger_select()

func _on_button_mouse_entered():
	$Audio/Hover.play()
