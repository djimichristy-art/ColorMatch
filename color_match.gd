extends Control

# Words and their colors
var words = ["RED", "BLUE", "GREEN", "YELLOW", "PURPLE", "ORANGE", "WHITE", "BLACK"]
var colors = [
	Color.RED,       # RED
	Color.BLUE,      # BLUE
	Color.GREEN,     # GREEN
	Color.YELLOW,    # YELLOW
	Color(0.56,0,1), # PURPLE
	Color(1,0.5,0),  # ORANGE
	Color.WHITE,     # WHITE
	Color.BLACK      # BLACK
]

# Game variables
var score := 0
var current_color : Color
var game_over := false
var time_left := 25

# Node references
@onready var word_label = $WordLabel
@onready var score_label = $ScoreLabel
@onready var timer_label = $TimerLabel
@onready var background = $Background
@onready var restart_btn = $ButtonContainer/RestartButton
@onready var red_btn = $ButtonContainer/RedButton
@onready var blue_btn = $ButtonContainer/BlueButton
@onready var green_btn = $ButtonContainer/GreenButton
@onready var yellow_btn = $ButtonContainer/YellowButton
@onready var purple_btn = $ButtonContainer/PurpleButton
@onready var orange_btn = $ButtonContainer/OrangeButton
@onready var white_btn = $ButtonContainer/WhiteButton
@onready var black_btn = $ButtonContainer/BlackButton
@onready var game_timer = $GameTimer

func _ready():
	randomize()

	# Reset UI
	score_label.text = "Score: 0"
	timer_label.text = "Time: " + str(time_left)
	word_label.text = ""
	restart_btn.visible = false

	# Set button colors
	red_btn.self_modulate = Color.RED
	blue_btn.self_modulate = Color.BLUE
	green_btn.self_modulate = Color.GREEN
	yellow_btn.self_modulate = Color.YELLOW
	purple_btn.self_modulate = Color(0.56,0,1)
	orange_btn.self_modulate = Color(1,0.5,0)
	white_btn.self_modulate = Color.WHITE
	black_btn.self_modulate = Color.BLACK

	# Connect buttons
	red_btn.pressed.connect(func(): _on_color_pressed(Color.RED))
	blue_btn.pressed.connect(func(): _on_color_pressed(Color.BLUE))
	green_btn.pressed.connect(func(): _on_color_pressed(Color.GREEN))
	yellow_btn.pressed.connect(func(): _on_color_pressed(Color.YELLOW))
	purple_btn.pressed.connect(func(): _on_color_pressed(Color(0.56,0,1)))
	orange_btn.pressed.connect(func(): _on_color_pressed(Color(1,0.5,0)))
	white_btn.pressed.connect(func(): _on_color_pressed(Color.WHITE))
	black_btn.pressed.connect(func(): _on_color_pressed(Color.BLACK))

	restart_btn.pressed.connect(_on_restart_pressed)

	# Setup timer
	game_timer.wait_time = 1
	game_timer.one_shot = false
	game_timer.timeout.connect(_on_timer_timeout)
	game_timer.start()

	show_new_word()


func show_new_word():
	if game_over:
		return

	# Background stays pink
	background.color = Color(1, 0.75, 0.8)

	# Random word
	word_label.text = words[randi() % words.size()]

	# Random word color
	current_color = colors[randi() % colors.size()]
	word_label.add_theme_color_override("font_color", current_color)


func _on_color_pressed(chosen_color: Color):
	if game_over:
		return

	if chosen_color == current_color:
		score += 1
	else:
		score = max(score - 1, 0)

	score_label.text = "Score: " + str(score)

	await get_tree().create_timer(0.4).timeout
	show_new_word()


func _on_timer_timeout():
	if game_over:
		return

	time_left -= 1
	timer_label.text = "Time: " + str(time_left)

	if time_left <= 0:
		game_over = true
		word_label.text = "GAME OVER"
		restart_btn.visible = true
		game_timer.stop()


func _on_restart_pressed():
	score = 0
	time_left = 25
	game_over = false

	score_label.text = "Score: 0"
	timer_label.text = "Time: " + str(time_left)
	restart_btn.visible = false

	game_timer.start()
	show_new_word()
