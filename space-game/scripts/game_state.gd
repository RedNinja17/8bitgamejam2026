extends Node

var health := 100.0
var money: float = 0.0
var bounty: float = 0.0
var market: Market = Market.new()
var fuel := FuelTank.new()
var cargo := CargoHold.new()
var player_pos: Vector2 = Vector2.ZERO

const MARKET_TICK_INTERVAL := 2.0

func _ready() -> void:
	var timer := Timer.new()
	timer.wait_time = MARKET_TICK_INTERVAL
	timer.autostart = true
	timer.timeout.connect(market.tick)
	add_child(timer)

func add_money(amount: float) -> void:
	money += amount

func add_bounty(amount: float) -> void:
	bounty += amount

func sell(value: float) -> void:
	money += value
	bounty += value
