extends Node2D

@onready var target_texture = preload("res://sprites/target.png")

var grid_size : int = 32
var grid_cell = Vector2(grid_size, grid_size)
var time : float
var alpha : float = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body. 

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("click") && is_mouse_on_tile():
		State.selected = get_mouse_index_vector() * grid_size
		State.is_selected = true

	if Input.is_action_just_pressed("next"):
		State.set_phase(State.PHASE.MOVE)
	time += delta
	alpha = (sin(time*8)+1)/2
	queue_redraw()

func _draw() -> void:
	var iv = get_mouse_index_vector()
	var tile = $TileMapLayer.get_cell_tile_data(iv)
	if tile != null:
		draw_rect(Rect2(iv * grid_size, grid_cell), Color(1, 1, 1, alpha), false, 2)
	if State.is_selected:
		draw_rect(Rect2(State.selected, grid_cell), Color(0, 1, 1, alpha), false, 2)
		if State.unit_map.has(State.selected):
			for x in range(-1, 2):
				var ti = State.selected + Vector2(x, 0)
				if $TileMapLayer.get_cell_tile_data(ti) != null:
					draw_texture(target_texture, ti * grid_size)

func get_index_vector(v: Vector2) -> Vector2:
	return floor(Vector2(v.x, v.y) / grid_size)

func get_mouse_index_vector() -> Vector2:
	return get_index_vector(get_global_mouse_position())

func is_mouse_on_tile() -> bool:
	return $TileMapLayer.get_cell_tile_data(get_mouse_index_vector()) != null
