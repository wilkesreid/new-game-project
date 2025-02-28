# Body component for unit
class_name Body extends Placeable

var parent : Unit

func _init(idx : Vector2i, par : Unit) -> void:
  index = idx
  parent = par
  State.units_container.add_child(self)

func _draw():
  draw_texture(parent.body_sprite, Vector2i(0, 0), Color(1, 1, 1, 1))