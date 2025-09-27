extends ColorRect

@export var player_status: Node
var blur_material: ShaderMaterial

# Intro variables
@onready var title_label: Label
@onready var press_start_label: Label
var blink_timer: float = 0.0
var blink_speed: float = 1.5
var intro_active: bool = true
var original_color: Color

func _ready():
	blur_material = material
	original_color = color
	
	if intro_active:
		setup_intro()

func setup_intro():
	# Temporarily hide blur and make it black for intro
	material = null
	color = Color.BLACK
	
	# Create title label
	title_label = Label.new()
	title_label.text = "YOUR GAME TITLE"
	title_label.add_theme_font_size_override("font_size", 64)
	title_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	title_label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	title_label.set_anchors_and_offsets_preset(Control.PRESET_CENTER)
	title_label.position.y -= 100
	add_child(title_label)
	
	# Create press start label
	press_start_label = Label.new()
	press_start_label.text = "PRESS ANY KEY TO START"
	press_start_label.add_theme_font_size_override("font_size", 24)
	press_start_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	press_start_label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	press_start_label.set_anchors_and_offsets_preset(Control.PRESET_CENTER)
	press_start_label.position.y += 50
	add_child(press_start_label)

func _process(delta: float):
	if intro_active:
		# Make "Press Start" blink
		blink_timer += delta * blink_speed
		var alpha = (sin(blink_timer) + 1.0) / 2.0
		press_start_label.modulate.a = lerp(0.3, 1.0, alpha)
	else:
		# Your original blur logic
		if player_status == null:
			return
		# Normalize vision (0.0–1.0 range)
		var vision_ratio = clamp(player_status.vision / 100.0, 0.0, 1.0)
		# Nonlinear falloff: squaring makes low vision feel much worse
		var blur_amount = 1.0 - pow(vision_ratio, 2.0)
		blur_material.set_shader_parameter("blur_strength", blur_amount)

func _input(event):
	if intro_active:
		if event is InputEventKey and event.pressed:
			start_game()
		elif event is InputEventMouseButton and event.pressed:
			start_game()

func start_game():
	intro_active = false
	
	# Fade out the intro
	var tween = create_tween()
	tween.tween_property(self, "modulate:a", 0.0, 1.0)
	tween.tween_callback(switch_to_blur)

func switch_to_blur():
	# Remove intro labels
	if title_label:
		title_label.queue_free()
	if press_start_label:
		press_start_label.queue_free()
	
	# Restore blur shader and original color
	material = blur_material
	color = original_color
	
	# Fade back in with blur
	var tween = create_tween()
	tween.tween_property(self, "modulate:a", 1.0, 0.5)
