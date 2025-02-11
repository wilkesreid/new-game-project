class_name Constellation extends Unit

func _init() -> void:
	texture = load('res://sprites/constellation.png')
	sprite_body = load('res://sprites/constellation_body.png')
	speed = 5
	max_size = 5
	super()
