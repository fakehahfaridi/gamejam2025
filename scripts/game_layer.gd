extends TileMapLayer

@export var map_size = Vector2i(10, 10)  # Size of the map grid
@export var atlas_default_coords = Vector2i(8, 5)  # Default ground tile coords
@export var atlas_bubble_coords = Vector2i(8, 4)  # Bubble tile coords
@export var atlas_hazard_coords = Vector2i(8, 4)  # Hazard tile coords
@export var bubble_spawn_chance = 0.2  # Probability of a bubble spawning
@export var hazard_spawn_chance = 0.1  # Probability of a hazard spawning

const CELL_SIZE = Vector2(16, 16)  # Fixed cell size in pixels

func _ready():
	generate_tiles()

func generate_tiles():
	for x in range(map_size.x):
		for y in range(map_size.y):
			var tile_coords = atlas_default_coords  # Default ground tile
			var random_value = randf()

			if random_value < bubble_spawn_chance:
				tile_coords = atlas_bubble_coords  # Place a bubble tile
			elif random_value < bubble_spawn_chance + hazard_spawn_chance:
				tile_coords = atlas_hazard_coords  # Place a hazard tile

			set_cell_atlas(Vector2i(x, y), tile_coords)

func set_cell_atlas(cell_pos: Vector2i, atlas_coords: Vector2i):
	# Use Atlas Coordinates for placement
	set_cell(cell_pos, 0, atlas_coords)  # 0 is the atlas ID for the TileSet
	

# Converts grid coordinates (Vector2i) to world coordinates (Vector2)
func map_to_world(tile_coords: Vector2i) -> Vector2:
	return Vector2(tile_coords) * CELL_SIZE

# Converts world coordinates (Vector2) to grid coordinates (Vector2i)
func world_to_map(world_coords: Vector2) -> Vector2i:
	return Vector2i(world_coords / CELL_SIZE)
