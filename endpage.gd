extends Control

@onready var restart_btn = $RestartButton
@onready var score_label = $ScoreLabel

var final_score: int = 0

func _ready():
	restart_btn.pressed.connect(_on_restart_pressed)

func show_score(score):
	final_score = score
	score_label.text = "Your Score: " + str(final_score)

func _on_restart_pressed():
	get_tree().change_scene_to_file("res://StartPage.tscn")
