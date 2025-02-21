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
  var result = get_closest_unit_path(enemy)
  var path = result[0]
  var target_unit = result[1]
  if path.size() == 0:
    await get_tree().create_timer(0).timeout
    return
  var move_path_size = path.size() - 1
  var moves_done = 0
  var did_ability = await try_ability(enemy, path, target_unit, moves_done)
  if did_ability:
    return
  for i in range(min(enemy.moves, move_path_size)):
    if !is_instance_valid(target_unit):
      break
    enemy.move_to(path[i])
    moves_done += 1
    # if enemy is in range to use their ability, go ahead and use it
    did_ability = await try_ability(enemy, path, target_unit, moves_done)
    await get_tree().create_timer(State.game_speed).timeout
    if did_ability:
      break

func try_ability(enemy : Enemy, path : Array[Vector2i], target_unit : Placeable, moves_done : int) -> bool:
  if enemy.abilities.size() > 0:
    var ability = enemy.abilities[0]
    if ability.distance >= (path.size() - moves_done):
      State.start_ability(ability, enemy)
      await get_tree().create_timer(State.game_speed).timeout # show indicators, wait a beat, then execute ability
      assert(State.ability_unit is Enemy, 'was about to start ability for enemy, but enemy is no longer valid. enemy may have been removed since starting the ability')
      ability.execute(target_unit.index)
      return true
    else:
      await get_tree().create_timer(0).timeout
      return false
  else:
    return false


func get_closest_unit_path(enemy : Enemy):
  var smallest_path : Array[Vector2i] = []
  var closest_unit : Placeable
  var units = State.map.values()
  for unit in units:
    if unit is Enemy or (unit is Body and unit.parent is Enemy):
      continue
    Asg.set_not_solid(unit.index)
    var path = Asg.get_id_path(enemy.index, unit.index)
    Asg.set_solid(unit.index)
    if path.size() > 0 and (smallest_path.size() == 0 or path.size() < smallest_path.size()):
      smallest_path = path
      closest_unit = unit
  return [smallest_path, closest_unit]

func remove(enemy : Enemy):
  enemies.erase(enemy)
  if enemies.size() == 0:
    State.phase = State.PHASE.WIN