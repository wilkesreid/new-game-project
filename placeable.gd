class_name Placeable extends Node2D

var effects : Array[Effect]

var index : Vector2i:
  get:
    return Coord.coord_to_index(position)
  set(value):
    position = Coord.index_to_coord(value)

func _init(idx) -> void:
  index = idx
  effects = []
  print('adding', self, 'at', idx)
  State.add(idx, self)
  if self is not Friendly:
    Phase.on_enemy.connect(on_enemy_turn_begin)
  else:
    Phase.on_move.connect(on_turn_begin)

func _ready():
  print('placeable ready', self)

func wait(time : int):
  await get_tree().create_timer(time).timeout

func on_enemy_turn_begin():
  for effect in effects:
    effect.do_tick()

func on_turn_begin():
  for effect in effects:
    effect.do_tick()