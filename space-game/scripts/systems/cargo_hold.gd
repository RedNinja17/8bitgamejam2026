class_name CargoHold
extends RefCounted

var items: Array[CargoItem] = []

func add(item: CargoItem) -> void:
	items.append(item)

func current_weight() -> float:
	var total := 0.0
	for item in items:
		total += item.weight
	return total

func sell_all(market: Market) -> float:
	var earned := 0.0
	for item in items:
		earned += item.sell_value(market)
	items.clear()
	return earned
