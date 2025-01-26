extends Label  # Assuming the label is a Label node

@export var blink_speed = 1.0  # Speed of the blinking effect

var time_elapsed: float = 0.0  # Tracks the elapsed time

func _process(delta):
	# Increment the elapsed time
	time_elapsed += delta

	# Apply a sine wave to modulate the alpha value
	modulate.a = 0.5 + 0.5 * sin(time_elapsed * blink_speed)
