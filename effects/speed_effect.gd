extends Effect
class_name SpeedEffect

var strength : int

func _init(l : int, s : int) -> void:
  name = 'Speed Boos'
  strength = s
  super(l)

func start():
  if parent is Unit:
    Sfx.play('Boost')
    if parent.moves == parent.speed:
      parent.speed += strength
    else:
      var prev_moves = parent.moves
      parent.speed += strength
      parent.moves = prev_moves + strength

func end():
  if parent is Unit:
    parent.speed -= 2