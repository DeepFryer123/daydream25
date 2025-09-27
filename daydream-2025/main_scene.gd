extends Node2D

const MAX_HEALTH = 100
var health = MAX_HEALTH
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	set_health_label()
	set_health_bar()
	
func update_health_ui():
	set_health_label()
	set_health_bar()
	
func set_health_label() -> void:
	$HealthLabel.text = "Health: %s" % health
	
	
func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		damage()


func set_health_bar() -> void:
	$Health.value = health

func damage() -> void:
	health-=5
	if health<0:
		health = MAX_HEALTH
	update_health_ui()
