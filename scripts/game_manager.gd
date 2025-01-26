extends Node

#var board_size = 4  # Current board size (NxN)

# Reference to the player and board
@onready var player = $Player
@onready var board = $GameLayer  # Replace 'GameLayer' with the correct node name
@onready var inventory = $Inventory  # Reference to the Inventory node

func _ready():
	if not has_node("Inventory"):
		add_child(inventory)  # Add inventory to the GameManager if not present
	else:
		inventory = $Inventory  # Get the existing Inventory node

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
	open_shop()

func open_shop():
	
	var shop_scene = load("res://Scenes/Shop.tscn")  # Load the Shop scene
	get_tree().change_scene_to_packed(shop_scene)  # Switch scenes

#func start_next_level():
	#setup_board()  # Reset the board after exiting the shop
