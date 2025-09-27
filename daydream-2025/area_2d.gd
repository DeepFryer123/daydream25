extends Area2D

# The sprite scene to spawn
@export var spawn_sprite_scene: PackedScene

func _ready():
	# Connect the input_event signal
	self.connect("input_event", Callable(self, "_on_input_event"))

func _on_input_event(viewport, event, shape_idx):
	# Check if left mouse button was pressed
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		spawn_sprite(event.position)

func spawn_sprite(click_position: Vector2):
	if spawn_sprite_scene:
		var new_sprite = spawn_sprite_scene.instantiate()
		# Center the sprite on the click
		if new_sprite.has_method("get_texture") and new_sprite.get_texture() != null:
			new_sprite.position = click_position - new_sprite.get_texture().get_size() / 2
		else:
			new_sprite.position = click_position
		get_parent().add_child(new_sprite)
		print("Spawned a sprite at ", new_sprite.position)
