extends SubViewport

@export var player: CharacterBody2D
var asteroid = preload("res://scenes/asteroid.tscn")

var min_radius = 250
var max_radius = 350
var despawn_radius = 600
var min_ring1 = 250
var max_ring1 = 300
var min_ring2 = 500
var max_ring2 = 600
var min_ring3 = 1000
var max_ring3 = 1100

var trash = []
var ring1 = []
var ring2 = []
var ring3 = []

func _ready() -> void:
	pass

func _process(delta: float) -> void:
	delete(trash)
	delete(ring1)
	delete(ring2)
	delete(ring3)
			
	if randf() < 0.5 && trash.size() < 50:
		var sp = trashSP()
		if not sp == Vector2.ZERO:
			spawn(sp, 1, trash)
	
	if randf() < 0.5 && ring1.size() < 10:
		var sp = ringSP(min_ring1, max_ring1)
		if not sp == Vector2.ZERO:
			spawn(sp, 2, ring1)
		
	if randf() < 0.5 && ring2.size() < 10:
		var sp = ringSP(min_ring2, max_ring2)
		if not sp == Vector2.ZERO:
			spawn(sp, 3, ring2)
		
	if randf() < 0.5 && ring3.size() < 10:
		var sp = ringSP(min_ring3, max_ring3)
		if not sp == Vector2.ZERO:
			spawn(sp, 4, ring3)
	
	
func spawn(pos: Vector2, type: int, arr: Array) -> void:
	var clone = asteroid.instantiate()
	clone.global_position = pos
	clone.setup(type)
	add_child(clone)
	arr.append(clone)

func delete(arr: Array) -> void:
	if not is_instance_valid(player):
		return
	for i in range(arr.size() - 1, -1, -1):
		var node = arr[i]
		if not is_instance_valid(node):
			arr.remove_at(i)
			continue
		if node.global_position.distance_to(player.global_position) > despawn_radius:
			arr.remove_at(i)
			node.queue_free()

func trashSP() -> Vector2:
	if not is_instance_valid(player):
		return Vector2.ZERO
	var angle = randf() * TAU
	var distance = randf_range(min_radius, max_radius)
	var offset = Vector2.RIGHT.rotated(angle) * distance
	var pos = player.global_position + offset
	if pos.length() > 250:
		return pos
	return Vector2.ZERO

func ringSP(ringMin: float, ringMax: float) -> Vector2:
	if not is_instance_valid(player):
		return Vector2.ZERO
	for attempt in 15:
		var angle = randf() * TAU
		var distance = randf_range(min_radius, max_radius)
		var pos = player.global_position + Vector2.RIGHT.rotated(angle) * distance
		var centerDistance = pos.length()
		if centerDistance >= ringMin and centerDistance <= ringMax:
			return pos
	return Vector2.ZERO
