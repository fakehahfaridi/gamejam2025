extends TileMapLayer

@export var map_size = Globals.board_size  # Size of the map grid
@export var atlas_default_coords = Vector2i(8, 5)  # Default ground tile coords
@export var atlas_bubble_coords = Vector2i(3, 8)  # Bubble tile coords
@export var atlas_hazard_coords = Vector2i(15, 22)  # Hazard tile coords
@export var bubble_spawn_chance = 0.2  # Probability of a bubble spawning
@export var hazard_spawn_chance = 0.1  # Probability of a hazard spawning

const CELL_SIZE = Vector2(16, 16)  # Fixed cell size in pixels
var tile_ids = {}  # Stores tile IDs keyed by grid position

func _ready():
	generate_tiles()
	
func is_hazard_tile(grid_pos: Vector2i) -> bool:
	var tile_coords = get_cell_atlas_coords(grid_pos)
	return tile_coords == atlas_hazard_coords


func generate_tiles():
	map_size = Globals.board_size
	clear()
	print("Depth level: ", Globals.depth_level)
	hazard_spawn_chance = (0.05 + log(Globals.depth_level + 1) / 5) / (Globals.board_size.length() * 0.5)
	print("Hazard spawn chance: ", hazard_spawn_chance)
	var current_id = 1  # Start numbering from 1
	for y in range(map_size.y):
		if y % 2 == 0:
			# Left-to-right for even rows
			for x in range(map_size.x):
				assign_tile(Vector2i(x, y), current_id)
				current_id += 1
		else:
			# Right-to-left for odd rows
			for x in range(map_size.x - 1, -1, -1):
				assign_tile(Vector2i(x, y), current_id)
				current_id += 1
	display_tile_numbers()
	
func assign_tile(grid_pos: Vector2i, tile_id: int):
	var tile_coords = atlas_default_coords  # Default tile

	# Randomly assign bubbles or hazards
	var random_value = randf()
	if random_value < bubble_spawn_chance:
		tile_coords = atlas_bubble_coords
	elif random_value < bubble_spawn_chance + hazard_spawn_chance:
		tile_coords = atlas_hazard_coords

		# Directly add the trap here for hazard tiles
		var hazards = get_node("Hazards")
		if hazards != null:
			hazards.add_hazard(map_to_world(grid_pos) + CELL_SIZE / 2)

	# Set the tile and store its ID
	set_cell_atlas(grid_pos, tile_coords)
	tile_ids[grid_pos] = tile_id  # Store the tile ID


func set_cell_atlas(cell_pos: Vector2i, atlas_coords: Vector2i):
	# Use Atlas Coordinates for placement
	set_cell(cell_pos, 0, atlas_coords)  # 0 is the atlas ID for the TileSet

func display_tile_numbers():
	for child in get_children():
		if child is Label:
			child.queue_free()
			
	for grid_pos in tile_ids.keys():
		var tile_id = tile_ids[grid_pos]
		var world_pos = map_to_world(grid_pos)
		
		# Create a Label node for the number
		var label = Label.new()
		label.text = str(tile_id)
		label.modulate = Color(1, 1, 1)  # Set text color to white
		label.size_flags_horizontal = Control.SIZE_EXPAND_FILL  # Expand horizontally
		label.size_flags_vertical = Control.SIZE_EXPAND_FILL
		
		# Adjust position to center the label on the tile
		label.position = world_pos + CELL_SIZE / 2 - Vector2(8, 8)  # Adjust for label size
		add_child(label)

# Reset the board with a new size
func reset_board(new_size: Vector2i):
	# Update the global board size
	Globals.board_size = new_size
	map_size = Globals.board_size
	Globals.calculate_board_size()

	# Clear existing tiles and labels
	clear()
	for child in get_children():
		if child is Label:
			child.queue_free()

	# Regenerate tiles for the new size
	generate_tiles()


# Converts grid coordinates (Vector2i) to world coordinates (Vector2)
func map_to_world(tile_coords: Vector2i) -> Vector2:
	return Vector2(tile_coords) * CELL_SIZE

# Converts world coordinates (Vector2) to grid coordinates (Vector2i)
func world_to_map(world_coords: Vector2) -> Vector2i:
	return Vector2i(world_coords / CELL_SIZE)
