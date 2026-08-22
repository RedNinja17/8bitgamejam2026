class_name CombatManager
extends RefCounted

signal enemy_defeated
signal player_hit(damage: float)
signal round_resolved(result: int)

var enemy_id: String
var enemy_health: float
var weak_points: int

func _init(id: String) -> void:
	enemy_id = id
	enemy_health = EnemyData.ENEMIES[id]["health"]
	weak_points = EnemyData.ENEMIES[id]["weak_points"]

func play_round(your_peek: int, your_shoot: int) -> Paintball.Result:
	var enemy := Paintball.enemy_choose()
	var result := Paintball.resolve(your_peek, your_shoot, enemy["peek"], enemy["shoot"])
	round_resolved.emit(result)

	if result == Paintball.Result.YOU_GOT_HIT or result == Paintball.Result.BOTH_HIT:
		player_hit.emit(10.0)

	return result

func apply_qte_damage(laser_damage: float, weak_points_hit: int) -> void:
	enemy_health -= laser_damage * weak_points_hit
	if enemy_health <= 0.0:
		enemy_health = 0.0
		enemy_defeated.emit()

func is_dead() -> bool:
	return enemy_health <= 0.0
