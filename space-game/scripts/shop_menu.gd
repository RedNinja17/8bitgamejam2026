extends CanvasLayer

var player_ref: Node2D = null

@onready var item_container: VBoxContainer = $PanelContainer/VBoxContainer/ScrollContainer/ItemListContainer
@onready var title_label: Label = $PanelContainer/VBoxContainer/Title
@onready var close_btn: Button = $PanelContainer/VBoxContainer/Close

func _ready() -> void:
	# Hide the UI when the game starts
	visible = false
	
	# Connect the close button once to hide instead of delete
	if not close_btn.pressed.is_connected(_on_close_pressed):
		close_btn.pressed.connect(_on_close_pressed)

func setup_shop(player: Node2D) -> void:
	player_ref = player
	visible = true
	_refresh_list()

func _on_close_pressed() -> void:
	visible = false

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventKey and event.pressed and not event.echo:
		if event.keycode == KEY_G:
			if visible:
				_on_close_pressed()
			else:
				open_shop_debug()

func open_shop_debug() -> void:
	if player_ref == null:
		player_ref = get_tree().get_first_node_in_group("player")
	
	if player_ref != null:
		setup_shop(player_ref)
	else:
		print("Debug Error: No node found in group 'player'")

func _refresh_list() -> void:
	for child in item_container.get_children():
		child.queue_free()

	if player_ref == null or not player_ref.has_method("return_inventory"):
		var empty := Label.new()
		empty.text = "Player data missing."
		item_container.add_child(empty)
		return

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
	return item.sell_value(GameState.market)

func _on_sell(entry: String, price: float) -> void:
	if player_ref and player_ref.has_method("remove_from_inventory"):
		player_ref.remove_from_inventory(entry)
	GameState.sell(price)
	print("SOLD ", entry, " for ₴", price)
	_refresh_list()
