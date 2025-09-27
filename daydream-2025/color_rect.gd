extends ColorRect

# How much to increase blur_strength per click
@export var blur_increment: float = 0.01

# How much to decrease health per click
@export var health_decrement: float = 0.1

# NodePath to your ProgressBar
@export var health_bar_path: NodePath

func _gui_input(event):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		increase_blur()
		decrease_health()

func increase_blur():
	var mat = material
	if mat and mat is ShaderMaterial:
		var current_blur = mat.get_shader_parameter("blur_strength")
		var new_blur = clamp(current_blur + blur_increment, 0.0, 1.0)
		mat.set_shader_parameter("blur_strength", new_blur)
		print("blur_strength updated to: ", new_blur)
	else:
		print("ColorRect does not have a ShaderMaterial")

func decrease_health():
	var health_bar = get_node_or_null(health_bar_path)
	if health_bar and health_bar is ProgressBar:
		# Decrease health and clamp to 0..max_value
		health_bar.value = clamp(health_bar.value - health_decrement * health_bar.max_value, 0, health_bar.max_value)
		print("Health decreased to: ", health_bar.value)
	else:
		print("Health ProgressBar not found or invalid")
