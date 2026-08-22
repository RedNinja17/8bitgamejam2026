class_name Market
extends RefCounted

const K := 0.03

var prices := {}

func _init() -> void:
	reset()

func reset() -> void:
	for id in OreData.ORES:
		var ore = OreData.ORES[id]
		prices[id] = (ore.min_price + ore.max_price) / 2.0

func tick() -> void:
	for id in OreData.ORES:
		prices[id] = _next_price(id)

func _next_price(id: String) -> float:
	var ore = OreData.ORES[id]
	var m: float = ore.min_price
	var M: float = ore.max_price
	var p: float = prices[id]
	var step := K * (M - m)
	var p_up := 1.0 - (p - m) / (M - m)
	if randf() < p_up:
		return min(M, p + step)
	else:
		return max(m, p - step)

func get_price(id: String) -> float:
	return prices[id]

func price_position(id: String) -> float:
	var ore = OreData.ORES[id]
	return (prices[id] - ore.min_price) / (ore.max_price - ore.min_price)
