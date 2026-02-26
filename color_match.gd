extends Control  # <-- CONTROL, not Node2D

# --- Variables ---
var COLORS = ["RED", "BLUE", "GREEN", "YELLOW", "PURPLE", "ORANGE", "WHITE", "BLACK"]
var COLOR_VALUES = {
	"RED": Color.RED,
	"BLUE": Color.BLUE,
	"GREEN": Color.GREEN,
	"YELLOW": Color.YELLOW,
	"PURPLE": Color(0.5, 0, 0.5),
	"ORANGE": Color(1, 0.5, 0),
	"WHITE": Color.WHITE,
	"BLACK": Color.BLACK
}

var current_color_name = ""
var score = 0

# --- Called when the scene is ready ---
func _ready():
	randomize()
	score = 0
	update_score_label()
	pick_new_color()
	
	# Assign each button its color name in metadata (all caps)
	$ButtonRed.set_meta("color_name", "RED")
	$ButtonBlue.set_meta("color_name", "BLUE")
	$ButtonGreen.set_meta("color_name", "GREEN")
	$ButtonYellow.set_meta("color_name", "YELLOW")
	$ButtonPurple.set_meta("color_name", "PURPLE")
	$ButtonOrange.set_meta("color_name", "ORANGE")
	$ButtonWhite.set_meta("color_name", "WHITE")
	$ButtonBlack.set_meta("color_name", "BLACK")
	
	# Connect all buttons to the same function
	for button in [$ButtonRed, $ButtonBlue, $ButtonGreen, $ButtonYellow, $ButtonPurple, $ButtonOrange, $ButtonWhite, $ButtonBlack]:
		button.connect("pressed", self, "_on_answer_button_pressed")

# --- Pick a new random color name ---
func pick_new_color():
	current_color_name = COLORS[randi() % COLORS.size()]
	$WordLabel.text = current_color_name  # Display the color word
	update_button_colors()

# --- Update button colors ---
func update_button_colors():
	for button in [$ButtonRed, $ButtonBlue, $ButtonGreen, $ButtonYellow, $ButtonPurple, $ButtonOrange, $ButtonWhite, $ButtonBlack]:
		var name = button.get_meta("color_name")
		button.modulate = COLOR_VALUES[name]

# --- Update score label ---
func update_score_label():
	$ScoreLabel.text = str(score)

# --- Called when any button is pressed ---
func _on_answer_button_pressed():
	var button = get_tree().get_sender()  # Get the button pressed
	var button_color = button.get_meta("color_name")
	
	if button_color == current_color_name:
		score += 1
	update_score_label()
	pick_new_color()
