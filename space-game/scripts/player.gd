extends CharacterBody2D

const MAX_SPEED = 400.0
var speed = 0.0
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
		speed = min(speed + MAX_SPEED * (delta * 2.0), MAX_SPEED)
		velocity = direction * speed
		
		print("speed: " + str(speed))
		rotation = lerp_angle(rotation, atan2(-velocity.y, -velocity.x), delta)
		move_and_slide()
	else:
		velocity = Vector2.ZERO
		speed = 0.0
