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
	
	# Get nodes safely
	var word_label = get_node_or_null("WordLabel")
	var score_label = get_node_or_null("ScoreLabel")
	var timer_label = get_node_or_null("TimerLabel")
	var restart_button = get_node_or_null("RestartButton")
	var game_timer = get_node_or_null("GameTimer")
	var red_button = get_node_or_null("ButtonContainer/RedButton")
	var blue_button = get_node_or_null("ButtonContainer/BlueButton")
	var green_button = get_node_or_null("ButtonContainer/GreenButton")
	var yellow_button = get_node_or_null("ButtonContainer/YellowButton")
	
	if not word_label or not score_label or not timer_label or not restart_button or not game_timer or not red_button or not blue_button or not green_button or not yellow_button:
		print("ERROR: One or more nodes not found. Check your scene tree and names.")
		return
	
	# Initialize UI
	score_label.text = "Score: 0"
	timer_label.text = "Time: " + str(time_left)
	restart_button.visible = false
	
	# Color the buttons
	red_button.self_modulate = Color.RED
	blue_button.self_modulate = Color.BLUE
	green_button.self_modulate = Color.GREEN
	yellow_button.self_modulate = Color.YELLOW
	
	# Connect buttons using bind (Godot 4)
	red_button.connect("pressed", Callable(self, "_on_color_pressed").bind(Color.RED))
	blue_button.connect("pressed", Callable(self, "_on_color_pressed").bind(Color.BLUE))
	green_button.connect("pressed", Callable(self, "_on_color_pressed").bind(Color.GREEN))
	yellow_button.connect("pressed", Callable(self, "_on_color_pressed").bind(Color.YELLOW))
	
	# Connect timer
	game_timer.connect("timeout", Callable(self, "_on_timer_timeout"))
	game_timer.start(1.0)  # 1-second countdown
	
	show_new_word()

# Show a new word in a random color
func show_new_word():
	if game_over:
		return
	
	var word_label = get_node("WordLabel")
	current_color = colors[randi() % colors.size()]
	word_label.text = words[randi() % words.size()]
	word_label.add_theme_color_override("font_color", current_color)

# Button pressed logic
func _on_color_pressed(chosen_color: Color):
	if game_over:
		return
	
	var score_label = get_node("ScoreLabel")
	if chosen_color == current_color:
		score += 1
	else:
		score -= 1
		if score < 0:
			score = 0
	score_label.text = "Score: " + str(score)
	
	# Wait 0.5 sec before showing new word
	await get_tree().create_timer(0.5).timeout
	show_new_word()

# Timer countdown
func _on_timer_timeout():
	if game_over:
		return
	
	time_left -= 1
	var timer_label = get_node("TimerLabel")
	timer_label.text = "Time: " + str(time_left)
	
	if time_left <= 0:
		game_over = true
		get_node("WordLabel").text = "GAME OVER"
		var restart_button = get_node_or_null("RestartButton")
		if restart_button:
			restart_button.visible = true
	else:
		get_node("GameTimer").start(1.0)

# Restart game
func _on_restart_button_pressed():
	score = 0
	time_left = 25
	game_over = false
	get_node("ScoreLabel").text = "Score: 0"
	get_node("TimerLabel").text = "Time: " + str(time_left)
	var restart_button = get_node_or_null("RestartButton")
	if restart_button:
		restart_button.visible = false
	show_new_word()
	get_node("GameTimer").start(1.0)
