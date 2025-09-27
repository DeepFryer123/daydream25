extends ProgressBar

# How much to decrease health per click (as a fraction of max_value)
@export var health_decrement: float = 1.0

func _gui_input(event):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		decrease_health()

func decrease_health():
	# Subtract a fraction of max_value
	value = clamp(value - health_decrement * max_value, 0, max_value)
	print("Health decreased to: ", value)
