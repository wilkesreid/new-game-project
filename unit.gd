extends Node2D

@export var texture : Texture2D

var speed : int = 1;

func move_to_index(target : Vector2) -> void:
  State.unit_move_index(Coord.coord_to_index(position), target)
  position = Coord.index_to_coord(target)

func move_to_coord(target : Vector2) -> void:
  State.unit_move_coord(position, target)
  position = target