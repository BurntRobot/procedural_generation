extends TileMap

func make_a_map(rooms):
	clear_layer(0)
	for col in range(rooms.size()):
		for row in range(rooms[col].size()):
			if rooms[col][row] != null:
				set_cell(0, Vector2(row,col), 0, Vector2(2, 4))
