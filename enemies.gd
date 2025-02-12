extends Node

var enemies : Array[Unit] = []

func _init():
  State.on_set_phase(func (phase : State.PHASE) -> void:
    if phase == State.PHASE.ENEMY:
      for enemy in enemies:
        enemy.moves = enemy.speed
        move_algo(enemy)
      State.set_phase(State.PHASE.MOVE)
  )

func move_algo(enemy : Enemy):
  var path = get_closest_unit_path(enemy)
  path.pop_back()
  if path.size() == 0:
    return
  for i in range(min(enemy.moves, path.size())):
    enemy.move_to(path[i])
    await get_tree().create_timer(.1).timeout

func get_closest_unit_path(enemy : Enemy):
  var smallest_path : Array[Vector2i] = []
  var units = State.map.values()
  for unit in units:
    if unit is Enemy or unit is Body:
      continue
    Asg.set_not_solid(unit.index)
    var path = Asg.get_id_path(enemy.index, unit.index)
    Asg.set_solid(unit.index)
    if smallest_path.size() == 0 or path.size() < smallest_path.size():
      smallest_path = path
  return smallest_path