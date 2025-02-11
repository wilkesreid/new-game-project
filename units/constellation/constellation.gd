extends "res://unit.gd"

func _ready() -> void:
	rs = preload("res://units/constellation/constellation.tscn")

	speed = 5
	max_size = 5
	super()
