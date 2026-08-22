extends RigidBody2D

# 1 = trash, 2 = close, 3 = medium, 4 = far
var type
var collectable

func _ready() -> void:
	pass

func setup(place: int) -> void:
	type = place
	collectable = true
	
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
