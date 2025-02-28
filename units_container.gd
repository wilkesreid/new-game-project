extends Node2D

func _ready() -> void:
  State.units_container = self

func _process(_delta : float):
  queue_redraw()

func _draw():
  pass
  # for enemy in Enemies.active_enemies:
    # draw_texture_rect(enemy.head_sprite, Rect2(enemy.position, Coord.grid_cell), false, Color(1, 1, 1, 1))
