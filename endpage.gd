extends Control

# Nodes
@onready var game_over_label = $GameOverLabel
@onready var restart_btn = $RestartButton
@onready var end_audio = $EndPageAudio

var score: int = 0  # optional if you want to show it later

func _ready():
	# Show score or message
	game_over_label.text = "Game Over! Score: " + str(score)

	# Play audio
	end_audio.play()

	# Connect restart
	if not restart_btn.pressed.is_connected(_on_restart_pressed):
		restart_btn.pressed.connect(_on_restart_pressed)

func _on_restart_pressed():
	get_tree().change_scene_to_file("res://StartPage.tscn")
