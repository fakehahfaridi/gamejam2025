extends Node

@export var initial_board_size = 4  # Starting board size (4x4)
@export var cell_size = 16  # Size of each tile in pixels

var board_size = initial_board_size  # Current board size
var score: int = 0
var score_multiplier: float = 1.0

# Adjusted node paths based on your hierarchy
@onready var player = get_node("../Player")  # Access Player node
@onready var game_layer = get_node("../GameLayer")  # Access GameLayer node
@onready var dice = get_node("/root/Main/Dice")  # Access Dice node
@onready var oxygen_bar = get_node("/root/Main/CanvasLayer/OxygenBar")  # Access OxygenBar node
@onready var score_label = get_node("/root/Main/CanvasLayer/ScoreLabel")  # Access ScoreLabel node

func _ready():
	if not player:
		push_error("Player node not found!")
	if not game_layer:  # Updated from "board"
		push_error("GameLayer node not found!")
	if not dice:
		push_error("Dice node not found!")
	if not oxygen_bar:  # Updated from "oxygen"
		push_error("OxygenBar node not found!")

	setup_board()
	player.connect("reached_end", Callable(self, "on_player_reached_end"))
	
	# Connect the dice rolled signal to the _on_dice_rolled method
	dice.connect("rolled", Callable(self, "_on_dice_rolled"))
	
func setup_board():
	print("Depth level: " + str(Globals.depth_level))
	board_size = calculate_board_size(Globals.depth_level)

	# Update the board with new size
	game_layer.map_size = Vector2i(board_size, board_size)  # Updated from "board"
	game_layer.generate_tiles()  # Updated from "board"

	# Reset player position and score components
	player.reset_position(Vector2i(0, 0))
	score_multiplier = 1.0  # Reset multiplier on new board

func calculate_board_size(level: int) -> int:
	return int(4 + pow(level - 1, 1.5))  # Non-linear size increase

func _on_player_moved(new_position: Vector2i, dice_roll: int):
	# Update score based on movement and dice roll
	score_multiplier += get_multiplier_from_dice(dice_roll)
	update_score()

func get_multiplier_from_dice(roll: int) -> float:
	match roll:
		1, 2: return 1.0
		3, 4: return 1.2
		5, 6: return 1.5
		_ : return 1.0

func apply_item_effect(multiplier_boost: float):
	# Call this when the player picks up an item
	score_multiplier += multiplier_boost
	update_score()

func update_score():
	score = int(score_multiplier * (Globals.depth_level * 10))  # Base score scaling with depth
	score_label.text = "Score: " + str(score)  # Update the UI
	print("Updated Score:", score)

func on_player_reached_end():
	var oxygen_bonus = oxygen_bar.get_remaining() * 5  # Updated from "oxygen"
	score += oxygen_bonus
	print("Oxygen Bonus:", oxygen_bonus)

	# Move to the next level
	Globals.depth_level += 1
	setup_board()


func _on_player_reached_end() -> void:
	pass # Replace with function body.
