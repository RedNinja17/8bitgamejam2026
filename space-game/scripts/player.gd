extends CharacterBody2D

const MAX_SPEED = 125.0
const ACEL_DUR = 1.5  # s
const DECEL_RATE = 100.0
const DECEL_EASE = 0.25
const TURN_SPEED = 8.0
var accel_time: float = 0.0
var speed: float = 0.0
var target: Vector2 = Vector2.ZERO

var inventory: Array = []

@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D

func _ready() -> void:
	target = global_position
	
func add_inventory(reward: String):
	inventory.append(reward)
	print("Asteriod collected")
	
var fuel = GameState.fuel
var cargo = GameState.cargo

func get_fuel_fraction() -> float:
	return fuel.fraction()

func get_cargo_weight() -> float:
	return cargo.current_weight()
	
func remove_from_inventory(entry: String) -> void:
	inventory.erase(entry)
	
func return_inventory() -> Array:
	return inventory
	
func rotate_to(asteriod: RigidBody2D):
	var target_pos = asteriod.get_global_position()
	var _angle = lerp_angle(rotation, atan2(target_pos.y, target_pos.x) + PI/2, 0.1)

func _physics_process(delta: float) -> void:
	var holding := Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT)
	if holding:
		target = get_global_mouse_position()

	var dist := global_position.distance_to(target)
	var accelerating := false

	if dist > 3.0:
		var direction := global_position.direction_to(target)
		var braking_dist := (speed * speed) / (2.0 * DECEL_RATE)

		if dist > braking_dist:
			accelerating = true
			accel_time = min(accel_time + delta, ACEL_DUR)
			var t := accel_time / ACEL_DUR
			speed = MAX_SPEED * (t * t)
		else:
			var decel := DECEL_RATE * (DECEL_EASE + (1.0 - DECEL_EASE) * (speed / MAX_SPEED))
			speed = max(speed - decel * delta, 0.0)
			sprite.play("idle")
			accel_time = sqrt(speed / MAX_SPEED) * ACEL_DUR

		var step: float = min(speed * delta, dist)
		velocity = direction * (step / delta)
		rotation = lerp_angle(rotation, velocity.angle() + PI / 2, TURN_SPEED * delta)
		move_and_slide()
	else:
		velocity = Vector2.ZERO
		speed = 0.0
		accel_time = 0.0

	var anim: StringName = "moving" if accelerating else "idle"
	if sprite.animation != anim or not sprite.is_playing():
		sprite.play(anim)
		
