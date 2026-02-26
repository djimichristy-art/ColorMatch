extends Control

# --- Nodes ---
@onready var restart_btn = $RestartButton
@onready var score_label = $ScoreLabel
@onready var end_audio = $EndPageAudio  # Your AudioStreamPlayer node with the mp3

var final_score: int = 0

func _ready():
	# Connect restart button
	if not restart_btn.pressed.is_connected(self._on_restart_pressed):
		restart_btn.pressed.connect(self._on_restart_pressed)

# --- Show final score and play sound ---
func show_score(score):
	final_score = score
	score_label.text = "Your Score: " + str(final_score)
	
	# Play game over sound
	end_audio.play()

# --- Restart button pressed ---
func _on_restart_pressed():
	# Optional: play click sound if you have one
	# end_audio.play()  # if you want same sound on restart
	
	get_tree().change_scene_to_file("res://StartPage.tscn")
