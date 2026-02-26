extends Control

@onready var start_button = $StartButton
@onready var start_audio = $StartPageAudio  # optional, if you have a sound

func _ready():
	start_button.pressed.connect(_on_start_pressed)

func _on_start_pressed():
	if start_audio:
		start_audio.play()
	# Load the ColorMatchGame scene
	get_tree().change_scene_to_file("res://ColorMatchGame.tscn")  # Make sure this path matches your file
