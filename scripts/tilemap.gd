extends TileMapLayer

@export var map_size = Vector2i(23, 23)  # Size of the map (width, height)
@export var atlas_tile_size = Vector2i(16, 16)  # Size of each tile in the atlas (in pixels)
@export var bubble_coords = Vector2i(8, 4)  # Coordinates in the atlas for the bubble tile
@export var hazard_coords = Vector2i(8, 3)  # Coordinates in the atlas for the hazard tile
@export var default_coords = Vector2i(8, 5)  # Coordinates in the atlas for the default tile
@export var bubble_spawn_chance = 0.2  # Probability of a bubble spawning
@export var hazard_spawn_chance = 0.1  # Probability of a hazard spawning

@export var atlas_texture: Texture2D  # Add a texture property to hold the atlas texture

func _ready():
	generate_tiles()

func generate_tiles():
	for x in range(map_size.x):
		for y in range(map_size.y):
			var atlas_coords = default_coords  # Default to normal tile coordinates
			var random_value = randf()

			if random_value < bubble_spawn_chance:
				atlas_coords = bubble_coords  # Use bubble tile coordinates
			elif random_value < bubble_spawn_chance + hazard_spawn_chance:
				atlas_coords = hazard_coords  # Use hazard tile coordinates

			set_cell_atlas(Vector2i(x, y), atlas_coords)  # Place the tile using atlas coordinates

func set_cell_atlas(tile_pos: Vector2i, atlas_coords: Vector2i):
	# Convert atlas coordinates to tile ID
	var atlas_id = get_atlas_tile_id(atlas_coords)
	set_cell(tile_pos, atlas_id)

func get_atlas_tile_id(atlas_coords: Vector2i) -> int:
	# Convert atlas coordinates to an atlas tile ID based on the texture size
	if not atlas_texture:
		print("Error: Atlas texture not assigned!")
		return -1
	var texture_size = atlas_texture.get_size()  # Get the size of the texture
	var tiles_per_row = texture_size.x / atlas_tile_size.x
	return atlas_coords.y * int(tiles_per_row) + atlas_coords.x
