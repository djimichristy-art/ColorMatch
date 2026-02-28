extends Control

@onready var start_button = $StartButton
@onready var start_audio = $StartPageAudio

func _ready():
	start_button.pressed.connect(_on_start_pressed)

func _on_start_pressed():
	if start_audio:
		start_audio.play()
	get_tree().change_scene_to_file("res://color_match.tscn")


func _on_start_button_pressed() -> void:
	pass # Replace with function body.
