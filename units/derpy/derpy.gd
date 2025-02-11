extends "res://unit.gd"

func _ready() -> void:
  rs = preload("res://units/derpy/derpy.tscn")

  speed = 4
  max_size = 3
  super()
