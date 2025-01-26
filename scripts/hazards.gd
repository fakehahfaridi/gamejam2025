extends Node2D

@export var hazard_texture: Texture = preload("res://other/icon.svg")  # Assign a texture for hazards in the editor

# Add a hazard at the given position
func add_hazard(position: Vector2):
	var hazard = Node2D.new()  # Create a new Node2D for the hazard
	hazard.position = position
	
	# Add a Sprite2D to represent the hazard visually
	var sprite = Sprite2D.new()
	sprite.texture = hazard_texture
	sprite.z_index = 1  # Ensure it renders above the tiles
	hazard.add_child(sprite)
	
	# Scale down the sprite
	sprite.scale = Vector2(0.1, 0.1)  # Adjust this to your desired size
	hazard.add_child(sprite)
	
	# Add the hazard to the Hazards node
	add_child(hazard)
