class_name Constellation extends Unit

func _ready() -> void:
	body = load('res://units/constellation/constellation_body.tscn')
	speed = 5
	max_size = 5
	super()
