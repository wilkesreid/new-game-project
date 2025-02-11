extends Enemy

func _ready() -> void:
  rs = preload("res://enemies/monstieur/monstieur.tscn")

  speed = 2
  super()