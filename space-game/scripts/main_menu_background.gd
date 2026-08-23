extends SubViewport

@onready var ship: AnimatedSprite2D = $AnimatedSprite2D
var offset: Vector2
var rotation: float
var shake_intensity: float = 0.5

func _ready() -> void:
	ship.play("default")
	offset = ship.offset
	rotation = ship.rotation
	
func _process(_delta: float) -> void:
	var x = randf_range(-shake_intensity, shake_intensity)
	var y = randf_range(-shake_intensity, shake_intensity)
	var rot = randf_range(-0.1, 0.1)
	
	ship.offset = offset + Vector2(x, y)
	ship.rotation = rotation + rot
