extends Node2D

const GAME_SCENE := "res://scenes/game.tscn"

var _blink := 0.0
var _show := true

func _process(delta: float) -> void:
	_blink += delta
	if _blink >= 0.5:
		_blink = 0.0
		_show = not _show
		queue_redraw()

	if Input.is_action_just_pressed("ui_accept"):
		get_tree().change_scene_to_file(GAME_SCENE)
	if Input.is_action_just_pressed("ui_cancel"):
		get_tree().quit()

func _draw() -> void:
	var font := ThemeDB.fallback_font
	var vp := get_viewport_rect().size   # this is now the SubViewport size

	draw_rect(Rect2(Vector2.ZERO, vp), Color(0, 0, 0))

	var title := "SPACE JANITOR"
	var ts := 64
	var tw := font.get_string_size(title, HORIZONTAL_ALIGNMENT_LEFT, -1, ts).x
	draw_string(font, Vector2((vp.x - tw) / 2, vp.y * 0.38), title, HORIZONTAL_ALIGNMENT_LEFT, -1, ts, Color.WHITE)
	draw_line(Vector2(vp.x/2 - tw/2, vp.y*0.4), Vector2(vp.x/2 + tw/2, vp.y*0.4), Color.WHITE, 2.0)

	if _show:
		var p := "PRESS ENTER TO START"
		var pw := font.get_string_size(p, HORIZONTAL_ALIGNMENT_LEFT, -1, 24).x
		draw_string(font, Vector2((vp.x - pw) / 2, vp.y * 0.58), p, HORIZONTAL_ALIGNMENT_LEFT, -1, 24, Color(0.8, 0.8, 0.8))

	var q := "[ESC] QUIT"
	var qw := font.get_string_size(q, HORIZONTAL_ALIGNMENT_LEFT, -1, 18).x
	draw_string(font, Vector2((vp.x - qw) / 2, vp.y * 0.66), q, HORIZONTAL_ALIGNMENT_LEFT, -1, 18, Color(0.5, 0.5, 0.5))
