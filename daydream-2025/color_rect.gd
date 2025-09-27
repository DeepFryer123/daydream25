extends ColorRect

# Gameplay variables
@export var blur_increment: float = 0.067
var health: float = 100.0
@export var health_decrement: float = 5.0

# Audio
@export var game_over_audio_path: String = "res://fahhh-pump-sound.mp3" # Replace with your audio file

# Intro variables
var intro_active: bool = true
var title_label: Label
var press_start_label: Label
var blink_timer: float = 0.0
var blink_speed: float = 1.5
var original_color: Color
var blur_material: ShaderMaterial

func _ready():
	blur_material = material
	original_color = color

	if intro_active:
		setup_intro()

func setup_intro():
	# Hide blur temporarily and make black
	material = null
	color = Color.BLACK
	
	# Create title label
	title_label = Label.new()
	title_label.text = "Beverage Simulator"
	title_label.add_theme_font_size_override("font_size", 64)
	title_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	title_label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	title_label.set_anchors_and_offsets_preset(Control.PRESET_CENTER)
	title_label.position.y -= 100
	add_child(title_label)
	
	# Create press start label
	press_start_label = Label.new()
	press_start_label.text = "Click to Start"
	press_start_label.add_theme_font_size_override("font_size", 24)
	press_start_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	press_start_label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	press_start_label.set_anchors_and_offsets_preset(Control.PRESET_CENTER)
	press_start_label.position.y += 50
	add_child(press_start_label)
	
	z_index = 2000
	modulate.a = 1.0

func _process(delta):
	if intro_active:
		# Blink "Click to Start"
		blink_timer += delta * blink_speed
		var alpha = (sin(blink_timer) + 1.0) / 2.0
		press_start_label.modulate.a = lerp(0.3, 1.0, alpha)
	else:
		# Update blur normally
		var mat = material
		if mat and mat is ShaderMaterial:
			var current_blur = mat.get_shader_parameter("blur_strength")
			mat.set_shader_parameter("blur_strength", clamp(current_blur, 0.0, 1.0))

func _input(event):
	if intro_active:
		if (event is InputEventKey or event is InputEventMouseButton) and event.pressed:
			start_intro_end()
	elif event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		increase_blur()
		decrease_health()

func start_intro_end():
	intro_active = false
	var tween = create_tween()
	tween.tween_property(self, "modulate:a", 0.0, 1.0)
	tween.tween_callback(switch_to_blur)

func switch_to_blur():
	if title_label:
		title_label.queue_free()
	if press_start_label:
		press_start_label.queue_free()
	
	material = blur_material
	color = original_color
	
	var tween = create_tween()
	tween.tween_property(self, "modulate:a", 1.0, 0.5)

# Gameplay functions
func increase_blur():
	var mat = material
	if mat and mat is ShaderMaterial:
		var current_blur = mat.get_shader_parameter("blur_strength")
		mat.set_shader_parameter("blur_strength", clamp(current_blur + blur_increment, 0.0, 1.0))
		print("blur_strength updated to: ", mat.get_shader_parameter("blur_strength"))

func decrease_health():
	health = max(health - health_decrement, 0)
	print("Health: ", health)

	if health <= 0:
		game_over()

func game_over():
	# Reset blur to 0
	var mat = material
	if mat and mat is ShaderMaterial:
		mat.set_shader_parameter("blur_strength", 0.0)
	
	# Black overlay
	var blackout := ColorRect.new()
	blackout.color = Color.BLACK
	blackout.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	get_tree().root.add_child(blackout)

	# End text
	var label := Label.new()
	label.text = "WOMP WOMP"
	label.add_theme_font_size_override("font_size", 64)
	label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	label.set_anchors_and_offsets_preset(Control.PRESET_CENTER)
	blackout.add_child(label)
	blackout.z_index = 9999

	# Play audio once
	if game_over_audio_path != "":
		var end_audio := AudioStreamPlayer.new()
		end_audio.stream = preload("res://fahhh-pump-sound.mp3")  # <-- path must be a string
		end_audio.volume_db = 10.0
		end_audio.autoplay = false
		get_tree().root.add_child(end_audio)
		end_audio.play()
