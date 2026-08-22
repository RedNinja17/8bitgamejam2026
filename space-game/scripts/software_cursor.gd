extends Node2D

var cursor: Sprite2D

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	Input.mouse_mode = Input.MOUSE_MODE_HIDDEN
	cursor = Sprite2D.new()
	cursor.texture = load("res://assets/sprites/crosshair_noring_48.png")
	cursor.scale = Vector2(1.0, 1.0)
	cursor.z_index = 4096
	add_child(cursor)

func _process(_delta: float) -> void:
	cursor.global_position = get_global_mouse_position()
