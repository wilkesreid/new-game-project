extends Node

var enemies = {
  'corrupted_eye': {
    'name': 'Corrupted Eye',
    'head_sprite': preload('res://sprites/enemies/corrupted_eye.png'),
    'body_sprite': preload('res://sprites/enemies/corrupted_eye_body.png'),
    'speed': 2,
    'max_size': 3,
    'abilities': [
      Ability.new({
        'name': 'Shoot',
        'distance': 2,
        'damage': 1
      })
    ]
  },
  'monstieur': {
    'name': 'Monstieur',
    'head_sprite': preload('res://sprites/enemies/monstieur.png'),
    'body_sprite': preload('res://sprites/enemies/monstieur_body.png'),
    'speed': 3,
    'max_size': 3,
    'abilities': [
      Ability.new({
        'name': 'Attack',
        'distance': 1,
        'damage': 2
      })
    ]
  }
}
var active_enemies : Array[Unit] = []

func _init():
  State.phase_enemy.connect(func ():
    if active_enemies.size() > 0:
      for enemy in active_enemies:
        enemy.moves = enemy.speed
        await move_algo(enemy)
    await instant()
    State.phase = State.PHASE.MOVE
  )

func move_algo(enemy : Enemy):
  await instant()
  var result = get_closest_unit_path(enemy)
  var path = result[0]
  var target_unit = result[1]
  if path.size() == 0:
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
    await tick()
    if did_ability:
      break

func try_ability(enemy : Enemy, path : Array[Vector2i], target_unit : Placeable, moves_done : int) -> bool:
  await instant()
  if enemy.abilities.size() > 0:
    var ability = enemy.abilities[0]
    if ability.distance >= (path.size() - moves_done):
      State.start_ability(ability, enemy)
      assert(State.ability_unit is Enemy, 'just started an ability, but it\'s already ended')
      await tick() # show indicators, wait a beat, then execute ability
      assert(State.ability_unit is Enemy, 'was about to start ability for enemy, but ability unit is no longer valid. ability may have been ended')
      await ability.execute(target_unit.index)
      return true
    else:
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
  active_enemies.erase(enemy)
  if active_enemies.size() == 0:
    State.phase = State.PHASE.WIN

func wait(time : float):
  await get_tree().create_timer(time).timeout

func instant():
  await wait(0)

func tick():
  await wait(State.game_speed)