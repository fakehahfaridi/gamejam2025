extends Camera2D

@export var vertical_center_threshold = 0.5  # Ratio of screen height for the center threshold

var locked_horizontal_position: float = 0.0  # Fixed horizontal position for the camera

func _ready():
	# Set the initial horizontal position based on the board size
	update_locked_horizontal_position()

func _process(delta):
	# Keep the camera horizontally locked
	global_position.x = locked_horizontal_position

	# Get the player's vertical position
	var player_y = get_parent().global_position.y

	# Smoothly update the camera's vertical position
	global_position.y = lerp(global_position.y, player_y, 5 * delta)
	
	update_locked_horizontal_position()

func update_locked_horizontal_position():
	# Calculate the center of the board in world coordinates
	var board_width_pixels = Globals.board_size.x * Globals.CELL_SIZE
	locked_horizontal_position = board_width_pixels / 2
