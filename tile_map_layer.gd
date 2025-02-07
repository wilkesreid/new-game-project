extends TileMapLayer

# positions must be tile index (not pixel coords)

func has_tile_at(pos : Vector2) -> bool:
	return tile_at(pos) != null

func tile_at(pos : Vector2) -> TileData:
	return get_cell_tile_data(pos)

