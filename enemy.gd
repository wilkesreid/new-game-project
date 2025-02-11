class_name Enemy extends Unit

func is_enemy() -> bool:
  return true

func _ready() -> void:
  State.add_existing_unit(index(), self)
  if is_head():
    State.on_set_phase(func (phase : State.PHASE) -> void:
      if phase == State.PHASE.ENEMY:
        var path = Asg.get_id_path(index(), index() + Vector2i(speed, 0))
        path.pop_front()
        for tile in path:
          move_to_index(tile)
          await get_tree().create_timer(.1).timeout
        State.set_phase(State.PHASE.MOVE)
  )
  super()
