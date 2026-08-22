extends RigidBody2D

# 1 = trash, 2 = close, 3 = medium, 4 = far
var type
var collectable

var player_in_range: bool = false
var player_ref: Node2D = null

@onready var net_detection_area: Area2D = $NetDetectionArea

func _ready() -> void:
	net_detection_area.body_entered.connect(_on_body_entered)
	net_detection_area.body_exited.connect(_on_body_exited)

func setup(place: int) -> void:
	type = place
	collectable = true
	
func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		player_in_range = true
		player_ref = body
		
func _on_body_exited(body: Node2D) -> void:
	if body.is_in_group("player"):
		player_in_range = false
		player_ref = null

func _unhandled_input(event: InputEvent) -> void:
	if player_in_range and event.is_mouse_button_pressed(MOUSE_BUTTON_MIDDLE):
		deploy_net()

func deploy_net() -> void:
	print("Net deployed")
	if(is_instance_valid(player_ref)):
		player_ref.get_node("AnimatedSprite2D").play("deploy_net")
		var reward = collect()
		player_ref.get_node("AnimatedSprite2D")._add_inventory(reward)
		
	$NetAnimation.play("netted")

func collect() -> String:
	var reward = ""
	if collectable == true:
		collectable = false
		# Decide size
		var size = randf_range(1, 100)
		if size <= 12.5:
			reward += "Small_"
		elif size <= 87.5:
			reward += "Average_"
		elif size <= 97.5:
			reward+= "Large_"
		else:
			reward += "Giant_"
		#Decide scarcity
		var scarcity = randf_range(1, 100)
		if scarcity <= 7.5:
			reward += "Sparse_"
		elif scarcity <= 27.5:
			reward += "Traces_"
		elif scarcity <= 77.5:
			reward+= "Standard_"
		elif scarcity <= 90.0:
			reward += "Rich_"
		elif scarcity <= 97.5:
			reward += "Dense_"
		else:
			reward += "Pure_"
		#Decide ore in rock
		var ore = randf_range(1, 100)
		if type == 1:
			reward += "Trash"
		elif type == 2:
			if ore <= 75.0:
				reward += "Copper"
			elif ore <= 90.0:
				reward += "Iron"
			elif ore <= 97.5:
				reward += "Platinum"
			else:
				reward += "Lithium"
		elif type == 3:
			if ore <= 15.0:
				reward += "Copper"
			elif ore <= 85.0:
				reward += "Iron"
			elif ore <= 95.0:
				reward += "Platinum"
			else:
				reward += "Lithium"
		else:
			if ore <= 10.0:
				reward += "Copper"
			elif ore <= 35.0:
				reward += "Iron"
			elif ore <= 85.0:
				reward += "Platinum"
			else:
				reward += "Lithium"
	return reward
