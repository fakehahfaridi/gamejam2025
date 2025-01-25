extends Area2D

func _on_body_entered(body):
	if body.name == "Player":
		body.add_oxygen(20)  # Add oxygen to player
		queue_free()
