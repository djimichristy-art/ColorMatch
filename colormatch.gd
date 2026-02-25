
extends Control

# Words and their colors
var words = ["RED", "BLUE", "GREEN", "YELLOW"]
var colors = [Color.RED, Color.BLUE, Color.GREEN, Color.YELLOW]

# Game variables
var score = 0
var current_color : Color
var game_over = false
var time_left = 30  # countdown timer in seconds

# Node references
@onready var word_label = $WordLabel
@onready var score_label = $ScoreLabel
@onready var timer_label = $TimerLabel
@onready var restart_button = $RestartButton
@onready var game_timer = $GameTimer
@onready var red_button = $RedButton
@onready var blue_button = $BlueButton
@onready var green_button = $GreenButton
@onready var yellow_button = $YellowButton

func _ready():
	randomize()
	score_label.text = "Score: 0"
	timer_label.text = "Time: " + str(time_left)
	restart_button.visible = false
	setup_buttons()
	show_new_word()
	game_timer.start()  # start the 1-second timer for countdown

# Safe automatic coloring using Self Modulate
func setup_buttons():
	red_button.self_modulate = Color.RED
	blue_button.self_modulate = Color.BLUE
	green_button.self_modulate = Color.GREEN
	yellow_button.self_modulate = Color.YELLOW

# Show a new word in a random color
func show_new_word():
	if game_over:
		return
		
	var random_word = words[randi() % words.size()]
	current_color = colors[randi() % colors.size()]
	word_label.text = random_word
	word_label.add_theme_color_override("font_color", current_color)

# Check if the player clicked the correct button
func check_answer(chosen_color: Color):
	if game_over:
		return
		
	if chosen_color == current_color:
		score += 1
	else:
		score -= 1
		if score < 0:
			score = 0

	score_label.text = "Score: " + str(score)

	# Wait 1 second before showing new word
	await get_tree().create_timer(1.0).timeout
	show_new_word()

# Button pressed signals
func _on_red_button_pressed():
	check_answer(Color.RED)

func _on_blue_button_pressed():
	check_answer(Color.BLUE)

func _on_green_button_pressed():
	check_answer(Color.GREEN)

func _on_yellow_button_pressed():
	check_answer(Color.YELLOW)

# GameTimer timeout runs every second
func _on_game_timer_timeout():
	if game_over:
		return
	
	time_left -= 1
	timer_label.text = "Time: " + str(time_left)
	
	if time_left <= 0:
		game_over = true
		word_label.text = "GAME OVER"
		restart_button.visible = true
	else:
		game_timer.start()  # restart timer for next second

# Restart button pressed
func _on_restart_button_pressed():
	score = 0
	time_left = 30
	game_over = false
	score_label.text = "Score: 0"
	timer_label.text = "Time: " + str(time_left)
	restart_button.visible = false
	show_new_word()
	game_timer.start()
