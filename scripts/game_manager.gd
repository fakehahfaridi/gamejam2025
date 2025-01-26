extends Node

@export var initial_board_size = 4  # Starting size of the board (4x4)
@export var cell_size = 16  # Size of each tile in pixels

var board_size = 4  # Current board size (NxN)

# Reference to the player and board
@onready var player = $Player
@onready var board = $GameLayer  # Replace 'GameLayer' with the correct node name

#func _ready():
	#player.connect("reached_end", self, "_on_player_reached_end")
	#setup_board()


func setup_board():
	# Calculate the current board size based on the depth level
	print("Depth level: " + str(Globals.depth_level))
	board_size = calculate_board_size(Globals.depth_level)

	# Update the GameLayer with the new board size
	board.map_size = Vector2i(board_size, board_size)  # Correctly assign map size
	board.generate_tiles()

	# Reset the player's position to the starting tile
	player.reset_position(Vector2i(0, 0))

func calculate_board_size(level: int) -> int:
	# Non-linear progression formula for board size
	return int(4 + pow(level - 1, 1.5))

func on_player_reached_end():
	# Increment depth level
	Globals.depth_level += 1

	# Setup the next depth level
	setup_board()
