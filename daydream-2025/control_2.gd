# IntroScreen.gd
# Attach this to a Control node that covers the full screen

extends Control

@onready var title_label: Label
@onready var press_start_label: Label
@onready var background: ColorRect

# Signal to notify when intro is finished
signal intro_finished

var blink_timer: float = 0.0
var blink_speed: float = 1.5  # How fast "Press Start" blinks

func _ready():
	# Create background
	background = ColorRect.new()
	background.color = Color.BLACK
	background.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	add_child(background)
	
	# Create title label
	title_label = Label.new()
	title_label.text = "YOUR GAME TITLE"
	title_label.add_theme_font_size_override("font_size", 64)
	title_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	title_label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	title_label.set_anchors_and_offsets_preset(Control.PRESET_CENTER)
	title_label.position.y -= 100  # Move up from center
	add_child(title_label)
	
	# Create press start label
	press_start_label = Label.new()
	press_start_label.text = "PRESS ANY KEY TO START"
	press_start_label.add_theme_font_size_override("font_size", 24)
	press_start_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	press_start_label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	press_start_label.set_anchors_and_offsets_preset(Control.PRESET_CENTER)
	press_start_label.position.y += 50  # Move down from center
	add_child(press_start_label)
	
	# Make sure intro screen is on top
	z_index = 2000
	
	# Skip fade-in for now - show immediately
	modulate.a = 1.0

func _process(delta):
	# Make "Press Start" blink
	blink_timer += delta * blink_speed
	var alpha = (sin(blink_timer) + 1.0) / 2.0  # Convert -1,1 to 0,1
	press_start_label.modulate.a = lerp(0.3, 1.0, alpha)

func _input(event):
	# Check for any key press or mouse click
	if event is InputEventKey and event.pressed:
		start_game()
	elif event is InputEventMouseButton and event.pressed:
		start_game()

func start_game():
	# Skip fade out for now - just finish immediately
	finish_intro()

func finish_intro():
	intro_finished.emit()
	queue_free()  # Remove the intro screen

# Optional: Call this to skip intro (for testing)
func skip_intro():
	finish_intro()
