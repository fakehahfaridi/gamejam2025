extends Node

# Global game variables
var depth_level = 1  # Current depth level
var board_size = Vector2i(4, 4)  # Current board size (NxN)
const CELL_SIZE = 16

# Helper to calculate the board size based on depth level
func calculate_board_size():
	var size = int(4 + pow(depth_level - 1, 1.5))
	if (size < 11):
		board_size = Vector2i(size, size)
	else:
		board_size = Vector2i(10, size)
