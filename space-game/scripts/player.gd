extends CharacterBody2D
const MAX_SPEED = 400.0
const TURN_SPEED = 6.0
var speed = 0.0
var target = Vector2.ZERO

func _ready() -> void:
	target = global_position

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("left_click") and speed == 0:
		target = get_global_mouse_position()

func _physics_process(delta: float) -> void:
	var dist = global_position.distance_to(target)
	if dist > 3.0:
		var direction = global_position.direction_to(target)
		speed = min(speed + MAX_SPEED * (delta * 2.0), MAX_SPEED)
		var step = min(speed * delta, dist)
		velocity = direction * (step / delta)
		rotation = lerp_angle(rotation, velocity.angle() + PI/2, TURN_SPEED * delta)
		move_and_slide()
	else:
		velocity = Vector2.ZERO
		speed = 0.0
