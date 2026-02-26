extends Control

# Words and their colors
var words = ["RED", "BLUE", "GREEN", "YELLOW", "PURPLE", "ORANGE", "WHITE", "BLACK"]
var colors = [
	Color.RED,
	Color.BLUE,
	Color.GREEN,
	Color.YELLOW,
	Color(0.56,0,1), # Purple
	Color(1,0.5,0),  # Orange
	Color.WHITE,
	Color.BLACK
]

# Game variables
var score := 0
var combo := 0
var current_color : Color
var game_over := false
var time_left := 25

# Node references
@onready var word_label = $WordLabel
@onready var score_label = $ScoreLabel
@onready var timer_label = $TimerLabel
@onready var background = $Background
@onready var restart_btn = $ButtonContainer/RestartButton
@onready var game_timer = $GameTimer

@onready var red_btn = $ButtonContainer/RedButton
@onready var blue_btn = $ButtonContainer/BlueButton
@onready var green_btn = $ButtonContainer/GreenButton
@onready var yellow_btn = $ButtonContainer/YellowButton
@onready var purple_btn = $ButtonContainer/PurpleButton
@onready var orange_btn = $ButtonContainer/OrangeButton
@onready var white_btn = $ButtonContainer/WhiteButton
@onready var black_btn = $ButtonContainer/BlackButton


func _ready():
	randomize()

	score = 0
	combo = 0
	time_left = 25
	game_over = false

	score_label.text = "Score: 0"
	timer_label.text = "Time: 25"
	restart_btn.visible = false
	background.color = Color(1, 0.75, 0.8)

	# CONNECT ALL COLOR BUTTONS
	red_btn.pressed.connect(func(): _on_color_pressed(Color.RED))
	blue_btn.pressed.connect(func(): _on_color_pressed(Color.BLUE))
	green_btn.pressed.connect(func(): _on_color_pressed(Color.GREEN))
	yellow_btn.pressed.connect(func(): _on_color_pressed(Color.YELLOW))
	purple_btn.pressed.connect(func(): _on_color_pressed(Color(0.56,0,1)))
	orange_btn.pressed.connect(func(): _on_color_pressed(Color(1,0.5,0)))
	white_btn.pressed.connect(func(): _on_color_pressed(Color.WHITE))
	black_btn.pressed.connect(func(): _on_color_pressed(Color.BLACK))

	# CONNECT RESTART BUTTON
	restart_btn.pressed.connect(_on_restart_pressed)

	# TIMER SETUP
	game_timer.wait_time = 1
	game_timer.timeout.connect(_on_timer_timeout)
	game_timer.start()

	show_new_word()


func show_new_word():
	if game_over:
		return

	var word_index = randi() % words.size()
	var color_index = randi() % colors.size()

	word_label.text = words[word_index]
	current_color = colors[color_index]
	word_label.add_theme_color_override("font_color", current_color)


func _on_color_pressed(chosen_color: Color):
	if game_over:
		return

	if chosen_color == current_color:
		combo += 1
		score += 1 + combo
		time_left = max(time_left - 1, 5) # reduce time but not below 5
	else:
		combo = 0
		score = max(score - 1, 0)

	score_label.text = "Score: " + str(score)
	timer_label.text = "Time: " + str(time_left)

	show_new_word()


func _on_timer_timeout():
	if game_over:
		return

	time_left -= 1
	timer_label.text = "Time: " + str(time_left)

	# Low time warning
	if time_left <= 5:
		background.color = Color(1, 0.4, 0.4)
	else:
		background.color = Color(1, 0.75, 0.8)

	if time_left <= 0:
		game_over = true
		game_timer.stop()
		word_label.text = "GAME OVER\nSCORE: " + str(score)
		restart_btn.visible = true


func _on_restart_pressed():
	score = 0
	combo = 0
	time_left = 25
	game_over = false

	score_label.text = "Score: 0"
	timer_label.text = "Time: 25"
	restart_btn.visible = false
	background.color = Color(1, 0.75, 0.8)

	game_timer.start()
	show_new_word()
