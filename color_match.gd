extends Control

# Words and their display colors
var words = ["RED", "BLUE", "GREEN", "YELLOW"]
var colors = [Color.RED, Color.BLUE, Color.GREEN, Color.YELLOW]

# Score and timer
var score = 0
var time_left = 20  # 20 seconds

# UI nodes
@onready var score_label = $ScoreLabel
@onready var word_label = $WordLabel
@onready var timer_label = $TimerLabel
@onready var red_button = $RedButton
@onready var blue_button = $BlueButton
@onready var green_button = $GreenButton
@onready var yellow_button = $YellowButton
@onready var game_timer = $GameTimer        # 1-second tick timer
@onready var background_timer = $BGTimer    # 3-second tick timer
@onready var root_control = self            # root node for changing background

# Current correct color index
var current_color_index = 0

func _ready():
	randomize()  # randomize words/colors

	# Set button colors
	red_button.add_color_override("font_color", Color.white)
	red_button.add_color_override("font_color_pressed", Color.white)
	red_button.add_color_override("font_color_hover", Color.white)
	red_button.add_color_override("font_color_disabled", Color.gray)
	red_button.add_color_override("bg_color", Color.red)

	blue_button.add_color_override("font_color", Color.white)
	blue_button.add_color_override("bg_color", Color.blue)

	green_button.add_color_override("font_color", Color.white)
	green_button.add_color_override("bg_color", Color.green)

	yellow_button.add_color_override("font_color", Color.black)
	yellow_button.add_color_override("bg_color", Color.yellow)

	# Connect buttons
	red_button.pressed.connect(self.check_answer.bind(0))
	blue_button.pressed.connect(self.check_answer.bind(1))
	green_button.pressed.connect(self.check_answer.bind(2))
	yellow_button.pressed.connect(self.check_answer.bind(3))

	# Setup game timer (1 second ticks)
	game_timer.wait_time = 1
	game_timer.one_shot = false
	game_timer.start()
	game_timer.timeout.connect(_on_timer_tick)

	# Setup background timer (3 seconds ticks)
	background_timer.wait_time = 3
	background_timer.one_shot = false
	background_timer.start()
	background_timer.timeout.connect(_on_background_change)

	# Initialize UI
	update_score()
	update_timer()
	show_new_word()

func show_new_word():
	if time_left <= 0:
		return
	var word_index = randi() % words.size()
	current_color_index = randi() % colors.size()
	word_label.text = words[word_index]
	word_label.add_color_override("font_color", colors[current_color_index])

func check_answer(button_index):
	if time_left <= 0:
		return  # game over
	if button_index == current_color_index:
		score += 1
	else:
		if score > 0:
			score -= 1
	update_score()
	show_new_word()

func update_score():
	score_label.text = "Score: %d" % score

func update_timer():
	timer_label.text = "Time: %d" % time_left

func _on_timer_tick():
	if time_left > 0:
		time_left -= 1
		update_timer()
	else:
		game_over()

func _on_background_change():
	# Randomly change background color
	root_control.add_color_override("custom_colors/bg_color", colors[randi() % colors.size()])

func game_over():
	game_timer.stop()
	background_timer.stop()
	word_label.text = "Game Over!"
	red_button.disabled = true
	blue_button.disabled = true
	green_button.disabled = true
	yellow_button.disabled = true
