class_name Enemy extends Unit

func _ready():
  Enemies.enemies.append(self)
  State.phase_change.connect(func (phase : State.PHASE) -> void:
    if phase == State.PHASE.ENEMY:
      moves = speed
  )
  super()
