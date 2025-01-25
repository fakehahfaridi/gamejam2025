extends CharacterBody2D

@export var cell_size = Vector2(16, 16)  # Size of each tile
@export var map_size = Vector2i(4, 4)  # Size of the map grid
@export var starting_tile = Vector2i(0, 0)  # Starting tile position

var current_tile = Vector2i(0, 0)  # Tracks the current tile position

func _ready():
	# Place the player on the starting tile
	position = current_tile_to_position(starting_tile)

func move_by_tiles(steps: int):
	# Calculate the final position after moving the given steps
	var new_tile = calculate_new_tile(steps)
	move_to_tile(new_tile)

func calculate_new_tile(steps: int) -> Vector2i:
	var tile_id = get_tile_id(current_tile) + steps  # Convert current tile to tile ID and add steps

	# Constrain the tile ID within bounds
	tile_id = clamp(tile_id, 1, map_size.x * map_size.y)

	# Convert the tile ID back to grid coordinates
	return tile_id_to_coords(tile_id)

func move_to_tile(tile_coords: Vector2i):
	# Update the current tile position
	current_tile = tile_coords

	# Move the player to the corresponding world position
	position = current_tile_to_position(tile_coords)

func current_tile_to_position(tile_coords: Vector2i) -> Vector2:
	# Convert grid coordinates to world position
	return Vector2(tile_coords) * cell_size

func get_tile_id(tile_coords: Vector2i) -> int:
	# Convert grid coordinates to a sequential tile ID based on zigzag logic
	var row = tile_coords.y
	var column = tile_coords.x

	if row % 2 == 0:
		# Left-to-right row
		return row * map_size.x + column + 1
	else:
		# Right-to-left row
		return (row + 1) * map_size.x - column

func tile_id_to_coords(tile_id: int) -> Vector2i:
	# Convert sequential tile ID back to grid coordinates
	var row = (tile_id - 1) / map_size.x
	var column = (tile_id - 1) % map_size.x

	if row % 2 == 0:
		# Left-to-right row
		return Vector2i(column, row)
	else:
		# Right-to-left row
		return Vector2i(map_size.x - column - 1, row)

func _process(delta):
	if Input.is_action_just_pressed("ui_right"):
		move_by_tiles(3)  # Move 1 tile forward
	elif Input.is_action_just_pressed("ui_left"):
		move_by_tiles(-3)  # Move 1 tile backward 
