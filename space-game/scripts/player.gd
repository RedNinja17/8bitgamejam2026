extends CharacterBody2D
const MAX_SPEED = 400.0
const ACEL_DUR = 3.0 #s
const DECEL_RATE = 300.0
var accel_time = 0;
const TURN_SPEED = 20.0
var speed = 0.0
var target = Vector2.ZERO

func _ready() -> void:
	target = global_position

#func _input(event: InputEvent) -> void:
	

func _physics_process(delta: float) -> void:
	
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		target = get_global_mouse_position()
	
	var dist = global_position.distance_to(target)
	
	if dist > 3.0:
		var direction = global_position.direction_to(target)
		var braking_dist = (speed * speed)/ (2 * DECEL_RATE)
		
		if dist > braking_dist:
			accel_time = min(accel_time + delta, ACEL_DUR)
			var t = accel_time / ACEL_DUR
			speed = MAX_SPEED * (t * t)
		else:
			speed = max(speed - DECEL_RATE * delta, 0.0)
			accel_time = sqrt(speed / MAX_SPEED) * ACEL_DUR
			
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
