class_name CargoItem
extends RefCounted

var ore_id: String
var base_value: float
var weight: float

const SIZE_MULT := {
	"Small": 0.5, "Average": 1.0, "Large": 2.5, "Giant": 5.0,
}
const SCAN_MULT := {
	"Sparse": 0.05, "Traces": 0.5, "Standard": 1.0,
	"Rich": 2.5, "Dense": 5.0, "Pure": 25.0,
}

const NAME_TO_ID := {
	"Trash": "space_trash", "Copper": "copper", "Iron": "iron",
	"Platinum": "platinum", "Lithium": "lithium",
}

static func from_reward(reward: String) -> CargoItem:
	var parts := reward.split("_")
	if parts.size() != 3:
		push_error("Malformed reward string: " + reward)
		return null

	var size_name: String = parts[0]
	var scan_name: String = parts[1]
	var ore_name: String = parts[2]

	var item := CargoItem.new()
	item.ore_id = NAME_TO_ID.get(ore_name, "space_trash")

	var ore = OreData.ORES[item.ore_id]
	var size_mult: float = SIZE_MULT.get(size_name, 1.0)
	var scan_mult: float = SCAN_MULT.get(scan_name, 1.0)

	var avg_price: float = (ore.min_price + ore.max_price) / 2.0
	item.base_value = avg_price * size_mult * scan_mult
	item.weight = ore.weight * size_mult

	return item

func sell_value(market: Market) -> float:
	var ore = OreData.ORES[ore_id]
	var avg_price: float = (ore.min_price + ore.max_price) / 2.0
	var market_ratio: float = market.get_price(ore_id) / avg_price
	return base_value * market_ratio
