extends Control

# Words and their colors
var words = ["RED", "BLUE", "GREEN", "YELLOW"]
var colors = [Color.RED, Color.BLUE, Color.GREEN, Color.YELLOW]

# Game variables
var score = 0
var current_color : Color
var game_over = false
var time_left = 25  # seconds

func _ready():
	randomize()
	
	# Initialize UI safely
	if $WordLabel: $WordLabel.text = ""
	if $ScoreLabel: $ScoreLabel.text = "Score: 0"
	if $TimerLabel: $TimerLabel.text = "Time: " + str(time_left)
	if $RestartButton: $RestartButton.visible = false
	
	# Color buttons safely
	if $ButtonContainer/RedButton: $ButtonContainer/RedButton.self_modulate = Color.RED
	if $ButtonContainer/BlueButton: $ButtonContainer/BlueButton.self_modulate = Color.BLUE
	if $ButtonContainer/GreenButton: $ButtonContainer/GreenButton.self_modulate = Color.GREEN
	if $ButtonContainer/YellowButton: $ButtonContainer/YellowButton.self_modulate = Color.YELLOW
	
	# Connect buttons safely
	if $ButtonContainer/RedButton: $ButtonContainer/RedButton.pressed.connect(Callable(self, "_on_color_pressed").bind(Color.RED))
	if $ButtonContainer/BlueButton: $ButtonContainer/BlueButton.pressed.connect(Callable(self, "_on_color_pressed").bind(Color.BLUE))
	if $ButtonContainer/GreenButton: $ButtonContainer/GreenButton.pressed.connect(Callable(self, "_on_color_pressed").bind(Color.GREEN))
	if $ButtonContainer/YellowButton: $ButtonContainer/YellowButton.pressed.connect(Callable(self, "_on_color_pressed").bind(Color.YELLOW))
	
	# Connect timer
	if $GameTimer:
		$GameTimer.timeout.connect(Callable(self, "_on_timer_timeout"))
		$GameTimer.start(1.0)
	
	show_new_word()

# Show a new word in random color
func show_new_word():
	if game_over:
		return
	current_color = colors[randi() % colors.size()]
	if $WordLabel:
		$WordLabel.text = words[randi() % words.size()]
		$WordLabel.add_theme_color_override("font_color", current_color)

# Button pressed logic
func _on_color_pressed(chosen_color: Color):
	if game_over:
		return
	if chosen_color == current_color:
		score += 1
	else:
		score -= 1
		if score < 0:
			score = 0
	if $ScoreLabel:
		$ScoreLabel.text = "Score: " + str(score)
	await get_tree().create_timer(0.5).timeout
	show_new_word()

# Timer countdown
func _on_timer_timeout():
	if game_over:
		return
	time_left -= 1
	if $TimerLabel:
		$TimerLabel.text = "Time: " + str(time_left)
	if time_left <= 0:
		game_over = true
		if $WordLabel: $WordLabel.text = "GAME OVER"
		if $RestartButton: $RestartButton.visible = true
	else:
		if $GameTimer: $GameTimer.start(1.0)

# Restart game
func _on_restart_button_pressed():
	score = 0
	time_left = 25
	game_over = false
	if $ScoreLabel: $ScoreLabel.text = "Score: 0"
	if $TimerLabel: $TimerLabel.text = "Time: " + str(time_left)
	if $RestartButton: $RestartButton.visible = false
	show_new_word()
	if $GameTimer: $GameTimer.start(1.0)
