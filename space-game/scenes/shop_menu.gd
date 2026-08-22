extends CanvasLayer

var player_ref: Node2D = null
var market: Market = null

@onready var item_container: VBoxContainer = $PanelContainer/VBoxContainer/ScrollContainer/ItemListContainer
@onready var title_label: Label = $PanelContainer/VBoxContainer/Title
@onready var close_btn: Button = $PanelContainer/VBoxContainer/Close

func setup_shop(player: Node2D) -> void:
	player_ref = player
	close_btn.pressed.connect(queue_free)
	_refresh_list()

func _refresh_list() -> void:
	for child in item_container.get_children():
		child.queue_free()

	var inventory: Array = player_ref.return_inventory()

	if inventory.is_empty():
		var empty := Label.new()
		empty.text = "Cargo hold empty."
		item_container.add_child(empty)
		return

	for entry in inventory:
		var item := CargoItem.from_reward(entry)
		if item == null:
			continue
		var price := _price_of(item)

		var row := HBoxContainer.new()

		var label := Label.new()
		label.text = "%s  -  ₴%.0f  (%.0f kg)" % [entry, price, item.weight]
		label.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		row.add_child(label)

		var sell_button := Button.new()
		sell_button.text = "Sell"
		sell_button.pressed.connect(_on_sell.bind(entry, price))
		row.add_child(sell_button)

		item_container.add_child(row)

func _price_of(item: CargoItem) -> float:
	if market != null:
		return item.sell_value(market)
	return item.base_value

func _on_sell(entry: String, price: float) -> void:
	player_ref.remove_from_inventory(entry)

	#player_ref.add_money(price)
	#player_ref.add_bounty(price)
	print("SOLD ", entry, " for ₴", price)

	_refresh_list()
