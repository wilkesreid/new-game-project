extends Node2D

@onready var target_texture = preload("res://sprites/target.png")

var time : float
var alpha : float = 0

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("click") && is_mouse_on_tile():
		State.select_at_mouse()

	if Input.is_action_just_pressed("next"):
		State.set_phase(State.PHASE.MOVE)
	time += delta
	alpha = (sin(time*8)+1)/2
	queue_redraw()

func _draw() -> void:
	var iv = Coord.get_mouse_index()
	if $TileMapLayer.has_tile_at(iv):
		draw_rect(Rect2(Coord.index_to_coord(iv), Coord.grid_cell), Color(1, 1, 1, alpha), false, 2)
	if State.is_selected:
		draw_rect(Rect2(State.selected_coords(), Coord.grid_cell), Color(0, 1, 1, alpha), false, 2)
		if State.has_unit_at_selected():
			for x in range(-1, 2):
				var ti = State.selected_index() + Vector2i(x, 0)
				if $TileMapLayer.has_tile_at(ti):
					draw_texture(target_texture, Coord.index_to_coord(ti))

func is_mouse_on_tile() -> bool:
	return $TileMapLayer.get_cell_tile_data(Coord.get_mouse_index()) != null
