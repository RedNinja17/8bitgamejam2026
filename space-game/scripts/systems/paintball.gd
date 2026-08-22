class_name Paintball
extends RefCounted

enum Result { NEITHER, YOU_HIT, YOU_GOT_HIT, BOTH_HIT }

static func resolve(your_peek: int, your_shoot: int, enemy_peek: int, enemy_shoot: int) -> Result:
	var you_land := your_shoot == enemy_peek
	var they_land := enemy_shoot == your_peek
	if you_land and they_land:
		return Result.BOTH_HIT
	elif you_land:
		return Result.YOU_HIT
	elif they_land:
		return Result.YOU_GOT_HIT
	else:
		return Result.NEITHER

static func enemy_choose() -> Dictionary:
	return { "peek": randi() % 3, "shoot": randi() % 3 }
