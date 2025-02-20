extends Node2D

@onready var target_texture = preload("res://sprites/target.png")

func _process(_delta: float) -> void:
  queue_redraw()

func _draw():
  if State.doing_ability:
    # draw indicators for where unit can attack
    var ability = State.current_ability
    # var ability_unit = State.ability_unit
    for x in range(-1 * ability.distance, ability.distance + 1):
      for y in range(-1 * ability.distance, ability.distance + 1):
        var t = State.ability_unit.index + Vector2i(x, y)
        var path = Asg.get_id_path_ignore_dest(State.ability_unit.index, t)
        if path.size() > 0 and path.size() <= ability.distance:
          draw_texture_rect(target_texture, Rect2i(Coord.index_to_coord(t), Coord.grid_cell), false, Color(1, 0, 0, 1))
