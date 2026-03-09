extends Control

# --- Constants ---
var COLORS = ["RED", "BLUE", "GREEN", "YELLOW", "PURPLE", "ORANGE", "WHITE", "BLACK"]
var COLOR_VALUES = {
	"RED": Color(1,0,0),
	"BLUE": Color(0,0,1),
	"GREEN": Color(0,1,0),
	"YELLOW": Color(1,1,0),
	"PURPLE": Color(0.5,0,0.5),
	"ORANGE": Color(1,0.5,0),
	"WHITE": Color(1,1,1),
	"BLACK": Color(0,0,0)
}

# --- Variables ---
var score: int = 0
var time_left: int = 20
var current_color_name: String = ""
var bg_timer_counter: float = 0

# --- Nodes ---
@onready var word_label =$TimerLabel 
@onready var score_label = $ScoreLabel
@onready var timer_label = $TimerLabel
@onready var timer = $GameTimer
$WordLabel@onready var buttons_container = $ButtonsContainer
@onready var background = $Background  # ColorRect

# --- Ready ---
func _ready():
	randomize()
	score = 0
	time_left = 20
	update_score_label()
	update_timer_label()
	pick_new_color()
	
	# Connect buttons
	if buttons_container:
		for button in buttons_container.get_children():
			var color_name = button.name.replace("Button","").to_upper()
			button.set_meta("COLOR_NAME", color_name)
			if COLOR_VALUES.has(color_name):
				button.modulate = COLOR_VALUES[color_name]
			if not button.pressed.is_connected(self._on_answer_button_pressed):
				button.pressed.connect(_on_answer_button_pressed, [button])
	
	if timer:
		timer.start()
	else:
		print("Timer node not found!")

# --- Pick new color ---
func pick_new_color():
	if COLORS.size() == 0: return
	current_color_name = COLORS[randi() % COLORS.size()]
	if word_label:
		word_label.text = current_color_name

# --- Button pressed ---
func _on_answer_button_pressed(button):
	if button == null: return
	var button_color = button.get_meta("COLOR_NAME")
	if button_color == current_color_name:
		score += 1
	update_score_label()
	pick_new_color()

# --- Labels ---
func update_score_label():
	if score_label:
		score_label.text = "Score: " + str(score)

func update_timer_label():
	if timer_label:
		timer_label.text = "Time: " + str(time_left)

# --- Background color change ---
func _process(delta):
	bg_timer_counter += delta
	if bg_timer_counter >= 3.0:
		bg_timer_counter = 0
		if background:
			# Lighter random colors so text is readable
			background.color = Color(randf()*0.6 + 0.4, randf()*0.6 + 0.4, randf()*0.6 + 0.4)

# --- Timer timeout ---
func _on_GameTimer_timeout():
	time_left -= 1
	update_timer_label()
	if time_left <= 0:
		if timer:
			timer.stop()
		var end_page = get_parent().get_node("EndPage")
		if end_page:
			end_page.show_score(score)
			self.visible = false
			end_page.visible = true
