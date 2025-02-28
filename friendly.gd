extends Unit
class_name Friendly

static func create(idx : Vector2i, key : String) -> Friendly:
  var friendly = Friendly.new(idx)
  friendly.set_stats(Friendlies.friendlies[key])
  return friendly

func _draw():
  draw_texture_rect(body_sprite, Rect2i(Vector2i(0, 0), Coord.grid_cell), false, Color(1, 1, 1, 1))
  draw_texture_rect(head_sprite, Rect2i(Vector2i(0, 0), Coord.grid_cell), false, Color(1, 1, 1, 1))