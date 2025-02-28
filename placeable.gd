class_name Placeable extends Node2D

var index : Vector2i:
  get:
    return Coord.coord_to_index(position)
  set(value):
    position = Coord.index_to_coord(value)

func _init(idx) -> void:
  index = idx
  print('adding', self, 'at', idx)
  State.add(idx, self)

func _ready():
  print('placeable ready', self)

func wait(time : int):
  await get_tree().create_timer(time).timeout
