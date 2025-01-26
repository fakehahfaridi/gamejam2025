extends Node

# Global game variables
var depth_level = 1  # Current depth level
var board_size = Vector2i(4, 4)  # Current board size (NxN)

# Helper to calculate the board size based on depth level
func calculate_board_size(level: int) -> Vector2i:
	var size = int(4 + pow(level - 1, 1.5))
	return Vector2i(size, size)
