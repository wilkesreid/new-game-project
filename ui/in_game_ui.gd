extends Control

var bottom_bar : Control

func _ready() -> void:
  bottom_bar = $BottomBar
  State.phase_change.connect(func (new_phase: State.PHASE) -> void:
    if new_phase == State.PHASE.MOVE:
      bottom_bar.show()
    else:
      bottom_bar.hide()
  )

func _on_end_turn_button_pressed() -> void:
  State.phase = State.PHASE.ENEMY
