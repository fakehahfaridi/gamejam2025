extends ColorRect

@export var fill_duration = 2.0  # Duration of the fill animation (in seconds)
@export var start_height = 0.0  # Initial height of the ColorRect (as a fraction of the screen height)
@export var end_height = 1.0    # Final height as a fraction of screen height (0.0 - 1.0)
@export var max_depth = 3  # Maximum depth level for full darkness

var time_elapsed: float = 0.0
var is_filling: bool = false
var initial_size: Vector2

func _ready():
	# Get the initial size of the ColorRect
	initial_size = size
	size = Vector2(initial_size.x, initial_size.y * start_height)  # Start at the bottom
	position = Vector2(0, get_viewport_rect().size.y - size.y)  # Align to the bottom

	# Start the submerging effect
	if Globals.new_run == true:
		Globals.new_run = false
		start_fill()
	else:
		filled()

func _process(delta):
	if is_filling:
		time_elapsed += delta

		# Calculate progress (0.0 to 1.0)
		var progress = clamp(time_elapsed / fill_duration, 0.0, 1.0)

		# Update the height based on progress
		var target_height = lerp(initial_size.y * start_height, initial_size.y * end_height, progress)
		size = Vector2(initial_size.x, target_height)
		position = Vector2(0, get_viewport_rect().size.y - size.y)  # Keep aligned to the bottom

		# End the fill when complete
		if progress >= 1.0:
			is_filling = false
			
	# Fetch depth level from Globals and calculate darkness
	var depth_level = Globals.depth_level
	var darkness = clamp(float(depth_level) / max_depth, 0.0, 1.0)

	# Update the shader's depth_darkness parameter
	if material is ShaderMaterial:
		var shader_material = material as ShaderMaterial
		shader_material.set("shader_parameter/depth_darkness", darkness)

func start_fill():
	# Start the fill animation
	time_elapsed = 0.0
	is_filling = true

func filled():
	# Set the size and position as if the fill is complete
	var target_height = initial_size.y * end_height
	size = Vector2(initial_size.x, target_height)
	position = Vector2(0, get_viewport_rect().size.y - size.y)  # Align to the bottom
	is_filling = false  # Ensure no further filling occurs
	
