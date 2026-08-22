extends StaticBody2D

var player_in_range: bool = false
var player_ref: Node2D = null

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		player_in_range = true
		player_ref = body
		
func _on_body_exited(body: Node2D) -> void:
	if body.is_in_group("player"):
		player_in_range = false
		player_ref = null

func _unhandled_input(event: InputEvent) -> void:
	if player_in_range and event is InputEventKey and Input.is_mouse_button_pressed(MOUSE_BUTTON_RIGHT):
			var shop_node = get_tree().root.find_child("ShopMenu", true, false)
			if shop_node and shop_node.has_method("setup_shop"):
				shop_node.visible = true
				shop_node.setup_shop(player_ref)
		
