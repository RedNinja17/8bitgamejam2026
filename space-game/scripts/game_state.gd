extends Node

var money: float = 0.0
var bounty: float = 0.0
var market: Market = Market.new()
var fuel := FuelTank.new()
var cargo := CargoHold.new()

func add_money(amount: float) -> void:
	money += amount

func add_bounty(amount: float) -> void:
	bounty += amount

func sell(value: float) -> void:
	money += value
	bounty += value
