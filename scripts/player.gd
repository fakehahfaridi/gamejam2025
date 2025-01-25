extends CharacterBody2D  # Or the base class for your player (e.g., KinematicBody2D)

@export var starting_tile = Vector2i(0, 0)  # Starting tile in the grid
@export var camera_zoom = Vector2(1, 1)  # Adjust camera zoom level if needed

func _ready():
	# Reference the TileMapLayer node (GameLayer)
	var game_layer = get_node("../GameLayer")  # Update path to match your scene
	if game_layer:
		position = get_starting_position(game_layer)  # Place the player
		setup_camera()
	else:
		print("GameLayer node not found!")

func get_starting_position(game_layer: TileMapLayer) -> Vector2:
	# Convert the starting tile position to world coordinates
	return game_layer.map_to_world(starting_tile)
	print()

func setup_camera():
	# Get the Camera2D node (assumes it's a child of the player)
	var camera = $Camera2D
	if camera:
		#camera.current = true  # Make this camera active
		camera.zoom = camera_zoom  # Adjust zoom
	else:
		print("No Camera2D found in Player node!")
