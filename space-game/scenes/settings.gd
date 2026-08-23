extends CanvasLayer

@onready var volume: VSlider = $Volume
@onready var brightness: VSlider = $Brightness
@onready var power: TextureButton = $Power

func _ready() -> void:
	volume.value_changed.connect(_on_volume_changed)
	brightness.value_changed.connect(_on_brightness_changed)
	power.pressed.connect(_on_power_pressed)

func _on_volume_changed(value: float) -> void:
	AudioServer.set_bus_volume_db(0, value)
	if value <= -79:
		AudioServer.set_bus_mute(0, true)
	else:
		AudioServer.set_bus_mute(0, false)
	
func _on_brightness_changed(value: float) -> void:
	pass
	
func _on_power_pressed(value: float) -> void:
	get_tree().quit()
