extends Control

var bottom_bar : Control

func _ready() -> void:
  bottom_bar = $BottomBar
  Phase.on_any.connect(func (new_phase):
    if new_phase == Phase.MOVE:
      bottom_bar.show()
    else:
      bottom_bar.hide()
  )

func _on_end_turn_button_pressed() -> void:
  Phase.phase = Phase.ENEMY
