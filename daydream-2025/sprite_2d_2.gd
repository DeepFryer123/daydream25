# Attach this directly to Sprite2D2
extends Sprite2D

# The sprite scene to spawn
@export var spawn_sprite_scene: PackedScene

# Position where the new sprite should appear
@export var spawn_position: Vector2 = Vector2(400, 300)

func _ready():
	# Make sure the sprite can receive input
	set_pickable(true)

func _gui_input(event):
	if event is InputEventMouseButton and event.button_index == BUTTON_LEFT and event.pressed:
		spawn_sprite()

func spawn_sprite():
	if spawn_sprite_scene:
		var new_sprite = spawn_sprite_scene.instantiate()
		new_sprite.position = spawn_position
		get_parent().add_child(new_sprite)
		print("Spawned a sprite at ", spawn_position)
