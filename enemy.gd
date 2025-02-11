class_name Enemy extends Unit

func _init() -> void:
  State.add_existing_unit(index(), self)
  State.on_set_phase(func (phase : State.PHASE) -> void:
    if phase == State.PHASE.ENEMY:
      var path = Asg.get_id_path(position, position + Vector2i(speed, 0))
      path.pop_front()
      for tile in path:
        move_to(tile)
      State.set_phase(State.PHASE.MOVE)
  )
