extends Node2D

var time : float
var alpha : float = 0

func _process(delta : float):
  time += delta
  alpha = (sin(time*8)+1)/2
  queue_redraw()

func _draw():
  # draw white rect around tile under mouse
  if State.tilemap_layer.has_tile_at(Coord.mouse_index()):
    draw_rect(Rect2(Coord.index_to_coord(Coord.mouse_index()), Coord.grid_cell), Color(1, 1, 1, 1), false, 2)
  
  # if any tile is selected
  if State.is_selected:
    # draw flashing blue rect around selected tile
    draw_rect(Rect2(State.selected_coord(), Coord.grid_cell), Color(0, 1, 1, 1), false, 2)