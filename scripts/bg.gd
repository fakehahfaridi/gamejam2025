extends Sprite2D

func _ready():
	# Ensure the background renders behind everything
	z_index = -999  # Set Z index to render behind everything
	z_as_relative = false  # Ensure this Z index is absolute
