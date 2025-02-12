class_name Derpy extends Unit

func _ready() -> void:
  body = load('res://units/derpy/derpy_body.tscn')
  speed = 4
  max_size = 3
  super()
