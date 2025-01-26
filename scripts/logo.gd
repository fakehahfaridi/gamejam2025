extends Sprite2D  # Assuming the logo is a Sprite2D

@export var bob_amplitude = 10.0  # Distance to move up and down
@export var bob_speed = 1.0       # Speed of the bobbing motion

var base_position: Vector2  # To store the initial position
var time_elapsed: float = 0.0  # Tracks the elapsed time

func _ready():
	# Store the starting position of the logo
	base_position = global_position

func _process(delta):
	# Increment the elapsed time
	time_elapsed += delta

	# Apply a sine wave to create the bobbing motion
	global_position.y = base_position.y + sin(time_elapsed * bob_speed) * bob_amplitude
