extends ProgressBar

@export var oxygen_depletion_rate = 1.0  # Oxygen loss per second
@export var max_oxygen = 100  # Maximum oxygen capacity
var oxygen = max_oxygen

func _ready():
	value = oxygen  # Initialize the ProgressBar value
	start_oxygen_depletion()

func start_oxygen_depletion():
	while oxygen > 0:
		await get_tree().create_timer(1).timeout  # Wait 1 second
		oxygen -= oxygen_depletion_rate
		value = oxygen  # Update the ProgressBar

		if oxygen <= 0:
			game_over()

func add_oxygen(amount: int):
	oxygen += amount
	oxygen = clamp(oxygen, 0, max_oxygen)  # Clamp to ensure it stays within bounds
	value = oxygen  # Update the ProgressBar

func game_over():
	print("Game Over")
	# Add game-over logic (e.g., signal emission, scene transition, etc.)
