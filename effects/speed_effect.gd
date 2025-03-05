extends Effect
class_name SpeedEffect

var strength : int

func _init(l : int, s : int) -> void:
  name = 'Speed Boost'
  # particle_color = Color(0.767, 0.476, 1, 1)
  strength = s
  super(l)

func start():
  if parent is Unit:
    super()
    Sfx.play('Boost')
    if parent.moves == parent.speed:
      parent.speed += strength
    else:
      var prev_moves = parent.moves
      parent.speed += strength
      parent.moves = prev_moves + strength

func end():
  if parent is Unit:
    super()
    parent.speed -= 2