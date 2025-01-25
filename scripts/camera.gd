extends Camera2D

@export var board_width = 10  # Width of the board in tiles
@export var cell_size = 16  # Size of each tile in pixels
@export var vertical_center_threshold = 0.5 # Ratio of screen height for the center threshold

var locked_horizontal_position: float = 0.0  # Fixed horizontal position for the camera

func _ready():
	# Calculate and set the horizontal position to half the board width
	locked_horizontal_position = ((board_width * cell_size) / 1.2)
	global_position.x = locked_horizontal_position

func _process(delta):
	# Keep the camera horizontally locked
	global_position.x = locked_horizontal_position

	# Get the player's vertical position
	var player_y = get_parent().global_position.y

	# Smoothly update the camera's vertical position
	global_position.y = lerp(global_position.y, player_y, 5 * delta)
