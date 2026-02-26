extends Control

@onready var start_button = $StartButton

func _ready():
	start_button.focus_mode = Control.FOCUS_NONE
	start_button.pressed.connect(_on_start_pressed)

func _on_start_pressed():
	get_tree().change_scene_to_file("res://color_match.tscn")
