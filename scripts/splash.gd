extends Node2D

@export var fade_duration = 1.0  # Duration of the fade effect
@export var next_scene_path = "res://scenes/MainScene.tscn"  # Path to the next scene
@onready var logo = $Logo
@onready var start_label = $StartLabel

var is_started = false  # Tracks whether the game has started

func _ready():
	# Ensure the splash screen is visible initially
	visible = true
	# Start a simple fade-in effect
	fade_in()

func _input(event):
	if (event.is_action_pressed("ui_accept") or event is InputEventMouseButton) and not is_started:
		start_game()

func start_game():
	is_started = true
	# Fade out only the logo and label
	fade_out_logo_and_label()

func fade_in():
	# Fade in the entire splash screen (if needed)
	var tween = create_tween()
	tween.tween_property(self, "modulate:a", 1.0, fade_duration)

func fade_out_logo_and_label():
	var tween = create_tween()

	# Fade out the logo
	tween.tween_property(logo, "modulate:a", 0.0, fade_duration)

	# Fade out the start label
	tween.tween_property(start_label, "modulate:a", 0.0, fade_duration)

	# Connect the tween finished signal
	tween.finished.connect(_on_tween_completed)

func _on_tween_completed():
	# Preload the next scene resource
	var next_scene = ResourceLoader.load(next_scene_path)
	if next_scene:
		get_tree().change_scene_to_file(next_scene_path)
	else:
		push_error("Failed to load scene: " + next_scene_path)
