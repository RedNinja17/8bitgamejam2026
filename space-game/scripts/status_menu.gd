extends Node2D

const PANEL_SIZE := Vector2(400, 320)

var is_open := false
var _prev_mmb := false
var _volume := 0.8

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	z_index = 5000
	_volume = _get_volume()

func _process(_delta: float) -> void:
	var mmb := Input.is_mouse_button_pressed(MOUSE_BUTTON_MIDDLE)
	if mmb and not _prev_mmb:
		is_open = not is_open
		get_tree().paused = is_open
	_prev_mmb = mmb

	if is_open:
		if Input.is_key_pressed(KEY_ESCAPE):
			is_open = false
			get_tree().paused = false
		_drag_slider()

	queue_redraw()

func _panel_pos() -> Vector2:
	return (get_viewport_rect().size - PANEL_SIZE) / 2.0

func _slider_rect() -> Rect2:
	var p := _panel_pos()
	return Rect2(p.x + 30, p.y + PANEL_SIZE.y - 60, PANEL_SIZE.x - 60, 20)

func _drag_slider() -> void:
	if not Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		return
	var m := get_global_mouse_position()
	var r := _slider_rect()
	if m.x >= r.position.x - 8 and m.x <= r.position.x + r.size.x + 8 \
			and m.y >= r.position.y - 14 and m.y <= r.position.y + r.size.y + 14:
		_volume = clampf((m.x - r.position.x) / r.size.x, 0.0, 1.0)
		_set_volume(_volume)

func _draw() -> void:
	if not is_open:
		return

	var p := _panel_pos()
	var font := preload("res://assets/fonts/PixelifySans-VariableFont_wght.ttf")

	# dim backdrop over the whole screen
	draw_rect(Rect2(-2000, -2000, 6000, 6000), Color(0, 0, 0, 0.6))

	# panel
	draw_rect(Rect2(p, PANEL_SIZE), Color(0, 0, 0))
	draw_rect(Rect2(p, PANEL_SIZE), Color(1, 1, 1), false, 2.0)

	var x := p.x + 30
	var y := p.y + 46

	draw_string(font, Vector2(x, y), "SHIP STATUS", HORIZONTAL_ALIGNMENT_LEFT, -1, 24, Color.WHITE)
	y += 40

	var stats := ["MONEY: 999", "BOUNTY: 250", "HEALTH: 80 / 100", "FUEL: 64%", "WEIGHT: 42 kg"]
	for line in stats:
		draw_string(font, Vector2(x, y), line, HORIZONTAL_ALIGNMENT_LEFT, -1, 20, Color.WHITE)
		y += 32

	# volume
	var r := _slider_rect()
	draw_string(font, Vector2(r.position.x, r.position.y - 10), "VOLUME", HORIZONTAL_ALIGNMENT_LEFT, -1, 20, Color.WHITE)
	draw_rect(r, Color(0.25, 0.25, 0.25))
	draw_rect(r, Color(1, 1, 1), false, 2.0)
	draw_rect(Rect2(r.position, Vector2(r.size.x * _volume, r.size.y)), Color(1, 1, 1))

	draw_string(font, Vector2(x, p.y + PANEL_SIZE.y - 18), "[MMB / ESC to close]", HORIZONTAL_ALIGNMENT_LEFT, -1, 16, Color(0.7, 0.7, 0.7))

func _get_volume() -> float:
	return db_to_linear(AudioServer.get_bus_volume_db(AudioServer.get_bus_index("Master")))

func _set_volume(v: float) -> void:
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"), linear_to_db(clampf(v, 0.0001, 1.0)))
