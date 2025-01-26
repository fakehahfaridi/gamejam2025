extends CharacterBody2D

@export var cell_size = Globals.CELL_SIZE  # Size of each tile
@export var map_size = Globals.board_size  # Size of the map grid
@export var starting_tile = Vector2i(0, 0)  # Starting tile position

var current_tile = Vector2i(0, 0)  # Tracks the current tile position
var target_position: Vector2  # Target world position for the player
var move_speed = 5.0  # Speed of movement (adjust as needed)
var is_moving = false  # Tracks if the player is currently moving
var move_queue: Array = []  # Queue of steps for movement

func _ready():
	# Initialize starting position
	target_position = current_tile_to_position(starting_tile)
	position = target_position

func reset_position(starting_tile: Vector2i):
	map_size = Globals.board_size
	target_position = current_tile_to_position(starting_tile)
	position = target_position
	current_tile = Vector2i(0, 0)
	is_moving = false
	move_queue.clear()
	print("reset pos")

func move_by_tiles(steps: int):
	# Add movement steps to the queue
	if steps != 0:
		move_queue.append(steps)
		if not is_moving:
			process_next_move()

func process_next_move():
	if move_queue.size() > 0:
		# Dequeue the next movement step
		var steps = move_queue.pop_front()
		var new_tile = calculate_new_tile(steps)
		move_to_tile(new_tile)

		# Determine if the player has reached the last tile
		var last_tile = Vector2i(
			(Globals.board_size.x - 1) if Globals.board_size.y % 2 != 0 else 0,
			Globals.board_size.y - 1
		)

		if new_tile == last_tile:
			print("Player reached the end of the board!")
			get_parent().on_player_reached_end()

func calculate_new_tile(steps: int) -> Vector2i:
	# Convert current tile to tile ID and add steps
	var tile_id = get_tile_id(current_tile) + steps
	tile_id = clamp(tile_id, 1, Globals.board_size.x * Globals.board_size.y)
	return tile_id_to_coords(tile_id)

func move_to_tile(tile_coords: Vector2i):
	if is_moving:
		return  # Ignore if already moving

	# Set the current tile and target position
	current_tile = tile_coords
	target_position = current_tile_to_position(tile_coords)
	is_moving = true

func current_tile_to_position(tile_coords: Vector2i) -> Vector2:
	return Vector2(tile_coords) * cell_size

func get_tile_id(tile_coords: Vector2i) -> int:
	var row = tile_coords.y
	var column = tile_coords.x

	if row % 2 == 0:
		return row * map_size.x + column + 1
	else:
		return (row + 1) * map_size.x - column

func tile_id_to_coords(tile_id: int) -> Vector2i:
	var row = (tile_id - 1) / map_size.x
	var column = (tile_id - 1) % map_size.x

	if row % 2 == 0:
		return Vector2i(column, row)
	else:
		return Vector2i(map_size.x - column - 1, row)

func _process(delta):
	if is_moving:
		position = position.lerp(target_position, move_speed * delta)

		# Snap to target position when close
		if position.distance_to(target_position) < 1.0:
			position = target_position
			is_moving = false

			# Check if the tile is a hazard
			var game_layer = get_parent().get_node("GameLayer")
			if game_layer.is_hazard_tile(current_tile):
				print("You stepped on a hazard!")
				move_by_tiles(-2)  # Add penalty movement
			else:
				# Process the next move in the queue
				process_next_move()

func _on_dice_rolled(result):
	move_by_tiles(result)
