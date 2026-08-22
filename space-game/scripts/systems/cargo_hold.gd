class_name CargoHold
extends RefCounted

var items: Array[CargoItem] = []
var max_capacity: float = 100.0

func _init(capacity: float = 100.0) -> void:
	max_capacity = capacity

func current_weight() -> float:
	var total := 0.0
	for item in items:
		total += item.weight
	return total

func space_left() -> float:
	return max_capacity - current_weight()

func can_fit(item: CargoItem) -> bool:
	return item.weight <= space_left()

func try_add(item: CargoItem) -> bool:
	if can_fit(item):
		items.append(item)
		return true
	return false

func sell_all(market: Market) -> float:
	var earned := 0.0
	for item in items:
		earned += item.sell_value(market)
	items.clear()
	return earned
	
func fullness() -> float:
	return current_weight() / max_capacity
