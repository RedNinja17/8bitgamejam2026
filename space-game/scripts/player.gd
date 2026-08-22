extends CharacterBody2D

const SPEED = 200.0
var target = Vector2.ZERO

func _ready() -> void:
	target = global_position
	print("hello")

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("left_click"):
		target = get_global_mouse_position()
		print("target acquired!")

func _physics_process(delta: float) -> void:
	if global_position.distance_to(target) > 3.0:
		var direction = global_position.direction_to(target)
		velocity = direction * SPEED
		move_and_slide()
	else:
		velocity = Vector2.ZERO
