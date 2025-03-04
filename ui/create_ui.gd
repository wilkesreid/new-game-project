extends Control

enum UNIT { CONSTELLATION, MIMI, DERPY }

func _ready() -> void:
	Phase.on_any.connect(func (new_phase):
		if new_phase != Phase.PLACE:
			queue_free()
	)

func _on_start_button_pressed() -> void:
	Phase.phase = Phase.MOVE
	State.retrigger_select()
