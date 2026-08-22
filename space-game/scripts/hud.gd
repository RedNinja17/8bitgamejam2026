extends CanvasLayer

var player_ref: Node2D = null

@onready var label: Label = $Readout

func _ready() -> void:
	if not has_node("Readout"):
		label = Label.new()
		label.name = "Readout"
		label.position = Vector2(60, 50)
		label.add_theme_color_override("font_color", Color(1, 1, 1))
		label.add_theme_font_size_override("font_size", 20)
		add_child(label)

func setup(player: Node2D) -> void:
	player_ref = player

func _process(_delta: float) -> void:
	label.text = _build_text()

func _build_text() -> String:
	return "MONEY  ₴%.0f\nBOUNTY ₴%.0f\nFUEL   %s %d%%\nWEIGHT %.0f kg" % [
		GameState.money,
		GameState.bounty,
		_bar(GameState.fuel.fraction(), 10),
		int(GameState.fuel.fraction() * 100),
		GameState.cargo.current_weight(),
	]

func _bar(frac: float, segments: int) -> String:
	var filled := int(round(clampf(frac, 0.0, 1.0) * segments))
	var s := ""
	for i in range(segments):
		s += "█" if i < filled else "░"
	return s
