extends Node

#var board_size = 4  # Current board size (NxN)

# Reference to the player and board
@onready var player = $Player
@onready var board = $GameLayer  # Replace 'GameLayer' with the correct node name

#func _ready():
	#setup_board()

func setup_board():
	# Update the current board size based on the depth level
	print("Depth level: " + str(Globals.depth_level))
	Globals.calculate_board_size()  # This updates Globals.board_size

	# Reset the board
	board.reset_board(Globals.board_size)

	# Reset the player's position to the starting tile
	player.reset_position(Vector2i(0, 0))

func on_player_reached_end():
	# Increment depth level
	Globals.depth_level += 1
	print("New depth level:", Globals.depth_level)
	
	# Recalculate the board size and reset the board
	Globals.calculate_board_size()
	setup_board()
