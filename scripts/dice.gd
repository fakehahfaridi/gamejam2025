extends Node2D

# Signal to emit the result
signal rolled(result: int)

# Function to roll the dice
func roll_dice() -> int:
	var result = randi() % 6 + 1  # Generate a random number between 1 and 6
	emit_signal("rolled", result)  # Emit the result for other nodes
	print("Dice rolled: ", result)  # Print the result for testing
	
	return result

# Called when the game starts
func _ready():
	randomize()  # Ensures unique random rolls each game session

# Detect the R key press
func _process(delta):
	if Input.is_action_just_pressed("roll_dice"):  # Detect the custom "roll_dice" action
		roll_dice()
