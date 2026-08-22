class_name UpgradeManager
extends RefCounted

signal upgrade_purchased(id: String, new_level: int)

var levels := {}

func _init() -> void:
	for id in UpgradeData.UPGRADES:
		levels[id] = 0

func get_value(id: String) -> float:
	var lvl: int = levels[id]
	return UpgradeData.UPGRADES[id]["levels"][lvl]["value"]

func can_upgrade(id: String) -> bool:
	var lvl: int = levels[id]
	return lvl + 1 < UpgradeData.UPGRADES[id]["levels"].size()

func next_cost(id: String) -> int:
	if not can_upgrade(id):
		return -1
	var next_lvl: int = levels[id] + 1
	return UpgradeData.UPGRADES[id]["levels"][next_lvl]["cost"]

func purchase(id: String) -> bool:
	if not can_upgrade(id):
		return false
	levels[id] += 1
	upgrade_purchased.emit(id, levels[id])
	return true
