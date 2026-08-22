class_name FuelTank
extends RefCounted

signal fuel_low
signal fuel_empty

var current: float
var max_fuel: float
var low_threshold: float = 0.2 

var burn_rate: float = 0.01

var _was_low := false

func _init(capacity: float = 100.0) -> void:
	max_fuel = capacity
	current = capacity

func consume(amount: float) -> float:
	var spent: float = min(amount, current)
	current -= spent

	if current <= 0.0:
		current = 0.0
		fuel_empty.emit()
	elif not _was_low and fraction() <= low_threshold:
		_was_low = true
		fuel_low.emit()

	return spent

const COST_PER_UNIT := 0.5

func refuel_cost() -> float:
	return (max_fuel - current) * COST_PER_UNIT

func refuel_full() -> void:
	current = max_fuel
	_was_low = false

const FUEL_PER_KG := 0.8

func burn_cargo(item_weight: float) -> void:
	current = min(max_fuel, current + item_weight * FUEL_PER_KG)
	if current > 0.0:
		_was_low = fraction() <= low_threshold

func fraction() -> float:
	return current / max_fuel

func is_empty() -> bool:
	return current <= 0.0
