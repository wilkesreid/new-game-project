extends Node

var enemies : Array[Unit] = []

func _init():
  State.phase_enemy.connect(func ():
    if enemies.size() > 0:
      for enemy in enemies:
        enemy.moves = enemy.speed
        await move_algo(enemy)
    await get_tree().create_timer(0).timeout
    State.phase = State.PHASE.MOVE
  )

func move_algo(enemy : Enemy):
  var path = get_closest_unit_path(enemy)
  path.pop_back()
  if path.size() == 0:
    await get_tree().create_timer(0).timeout
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

func remove(enemy : Enemy):
  enemies.erase(enemy)
  if enemies.size() == 0:
    State.phase = State.PHASE.WIN