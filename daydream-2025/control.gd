# CustomCursor.gd
# Attach this script to a Control node or CanvasLayer

extends Control

@onready var cursor_sprite: TextureRect
var open_cursor_texture: Texture2D
var closed_cursor_texture: Texture2D

func _ready():
	# Hide the system cursor
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	
	# Load both cursor textures
	open_cursor_texture = load("res://back1 (1).png")
	closed_cursor_texture = load("res://back21.png")
	
	# Create the cursor sprite
	cursor_sprite = TextureRect.new()
	add_child(cursor_sprite)
	
	# Set cursor properties
	cursor_sprite.texture = open_cursor_texture
	cursor_sprite.custom_minimum_size = Vector2(32, 32)
	cursor_sprite.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	
	# Center the cursor on mouse position
	cursor_sprite.anchor_left = 0.5
	cursor_sprite.anchor_top = 0.5
	cursor_sprite.anchor_right = 0.5
	cursor_sprite.anchor_bottom = 0.5
	
	# Make sure cursor stays on top
	z_index = 1000

func _process(delta):
	# Update cursor position to follow mouse
	var mouse_pos = get_global_mouse_position()
	cursor_sprite.global_position = mouse_pos - cursor_sprite.size / 2

func _input(event):
	# Change cursor image on mouse click
	if event is InputEventMouseButton:
		if event.pressed:
			# Mouse pressed - show closed hand
			cursor_sprite.texture = closed_cursor_texture
			cursor_sprite.modulate = Color(0.9, 0.9, 0.9)
		else:
			# Mouse released - show open hand
			cursor_sprite.texture = open_cursor_texture
			cursor_sprite.modulate = Color.WHITE

# Utility functions
func show_system_cursor():
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	
func hide_system_cursor():
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
