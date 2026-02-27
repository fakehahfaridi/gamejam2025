extends Node2D

# Signal to emit the result
signal rolled(result: int)

@export var num_faces = 6  # Number of faces on the dice
@export var face_probabilities = [0.05, 0.1, 0.15, 0.2, 0.25, 0.25] # Probabilities for each face (array of floats)

# Function to roll the dice
func roll_dice() -> int:
	# Ensure probabilities are valid
	if face_probabilities.size() != num_faces:
		push_error("Face probabilities do not match the number of faces!")
		print("Sum of face probabilities: ", face_probabilities.sum())

		return -1

	if abs(sum_array(face_probabilities) - 1.0) > 0.01:
		push_error("Face probabilities must sum to 1.0!")
		return -1

	# Generate a random result based on the probabilities
	var random_value = randf()
	var cumulative_probability = 0.0

	for i in range(num_faces):
		cumulative_probability += face_probabilities[i]
		if random_value <= cumulative_probability:
			emit_signal("rolled", i + 1)  # Emit the result (1-based index)
			print("Dice rolled:", i + 1)  # Print the result for testing
			return i + 1

	# Fallback (should not occur if probabilities are set correctly)
	push_error("Random value exceeded cumulative probability range!")
	return -1

func sum_array(arr: Array) -> float:
	var total = 0.0
	for value in arr:
		total += value
	return total


# Called when the game starts
func _ready():
	randomize()  # Ensures unique random rolls each game session

# Detect the R key press
func _process(delta):
	if Input.is_action_just_pressed("roll_dice"):  # Detect the custom "roll_dice" action
		roll_dice()
