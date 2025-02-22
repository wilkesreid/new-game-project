class_name Placeable extends Node2D

var index : Vector2i:
  get:
    return Coord.coord_to_index(position)
  set(value):
    position = Coord.index_to_coord(value)

func _ready() -> void:
  State.add(index, self)


func wait(time : int):
  await get_tree().create_timer(time).timeout