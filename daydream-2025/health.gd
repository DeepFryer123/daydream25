extends ProgressBar

# How much to decrease health per click (in raw units, not %)
@export var health_decrement: float = 10.0

func _ready() -> void:
	value = max_value  # Start at full health

func _gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		decrease_health()

func decrease_health() -> void:
	value = clamp(value - health_decrement, 0.0, float(max_value))
	print("Health decreased to: ", value)

	if value <= 0.0:
		game_over()

func game_over() -> void:
	print("GAME OVER - womp womp")

	# Create a black overlay
	var blackout := ColorRect.new()
	blackout.color = Color.BLACK
	blackout.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	get_tree().root.add_child(blackout)

	# Add game over text
	var label := Label.new()
	label.text = "WOMP WOMP"
	label.add_theme_font_size_override("font_size", 64)
	label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	label.set_anchors_and_offsets_preset(Control.PRESET_CENTER)
	blackout.add_child(label)

	# Put overlay on top
	blackout.z_index = 9999
