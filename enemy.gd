class_name Enemy extends Unit

func _ready():
  Enemies.enemies.append(self)
  State.on_set_phase(func (phase : State.PHASE) -> void:
    if phase == State.PHASE.ENEMY:
      moves = speed
  )
  super()
