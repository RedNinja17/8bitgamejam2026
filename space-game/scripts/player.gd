extends CharacterBody2D
const MAX_SPEED = 400.0
const TURN_SPEED = 6.0
const DECEL_RATE = 300.0
const ACCEL_DUR = 1.5 #1.5 seconds to reach max speed
var accel_time = 0.0
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
		var braking_distance = (speed * speed) / (2.0 * DECEL_RATE)
		
		if dist > braking_distance:
			accel_time = min(accel_time + delta, ACCEL_DUR)
			var t = accel_time / ACCEL_DUR
			speed = MAX_SPEED * (t * t)
		else: 
			speed = max(speed - DECEL_RATE * delta, 0.0) 
			accel_time = sqrt(speed / MAX_SPEED) * ACCEL_DUR
			
		var step = min(speed * delta, dist)
		velocity = direction * (step / delta)
		rotation = lerp_angle(rotation, velocity.angle() + PI/2, TURN_SPEED * delta)
		$AnimatedSprite2D.play("moving")
		move_and_slide()
	else:
		velocity = Vector2.ZERO
		$AnimatedSprite2D.play("idle")
		speed = 0.0
		accel_time = 0.0
