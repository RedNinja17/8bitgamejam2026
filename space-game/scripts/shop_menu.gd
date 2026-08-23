extends CanvasLayer

var player_ref: Node2D = null
@onready var title_label: Label = $VBoxContainer/Title
@onready var close_btn: Button = $VBoxContainer/Close
@onready var item_container: Control = $VBoxContainer/ScrollContainer/ItemList

func _ready() -> void:
	process_mode = PROCESS_MODE_ALWAYS
	visible = false
	if not close_btn.pressed.is_connected(_on_close_pressed):
		close_btn.pressed.connect(_on_close_pressed)

func _input(event: InputEvent) -> void:
	if event is InputEventKey and event.pressed and not event.echo:
		if event.keycode == KEY_G:
			if visible:
				_on_close_pressed()
			else:
				open_shop_debug()
		elif event.keycode == KEY_H:
			_sell_everything()
		#DEBUG - DELETE ME 
		elif event.keycode == KEY_M:
			GameState.add_money(2000)
			print("DEBUG: Granted money. Total: ₴", GameState.money)
			if visible:
				_refresh_list()
		elif event.keycode == KEY_R:
			_refuel()
		elif visible:
			var ids := ["speed", "thrust", "laser_damage", "laser_focus"]
			var idx := -1
			if event.keycode == KEY_1: idx = 0
			elif event.keycode == KEY_2: idx = 1
			elif event.keycode == KEY_3: idx = 2
			elif event.keycode == KEY_4: idx = 3
			if idx >= 0 and idx < ids.size():
				_buy_upgrade(ids[idx])

func open_shop_debug() -> void:
	print("DEBUG: G Key Pressed")
	if player_ref == null:
		player_ref = get_tree().get_first_node_in_group("player")
	if player_ref != null:
		print("DEBUG: Player found! Opening shop...")
		setup_shop(player_ref)
	else:
		print("DEBUG ERROR: Pressed G, but no node was found in group 'player'!")
		
func _refuel() -> void:
	const REFUEL_COST := 1000.0
	if GameState.fuel.fraction() >= 1.0:
		print("R: Tank already full")
		return
	if GameState.money < REFUEL_COST:
		print("R: Not enough money to refuel (need ₴", REFUEL_COST, ")")
		return
	GameState.money -= REFUEL_COST
	GameState.fuel.refuel_full()
	print("R: refueled for ₴", REFUEL_COST, ". money now ₴", GameState.money)
	if visible:
		_refresh_list()

func setup_shop(player: Node2D) -> void:
	player_ref = player
	visible = true
	_refresh_list()

func _on_close_pressed() -> void:
	visible = false

func _refresh_list() -> void:
	for child in item_container.get_children():
		child.queue_free()

	# --- cargo section ---
	if player_ref == null or not player_ref.has_method("return_inventory"):
		var empty := Label.new()
		empty.text = "Player reference missing or invalid."
		item_container.add_child(empty)
	else:
		var inventory: Array = player_ref.return_inventory()
		if inventory.is_empty():
			var empty := Label.new()
			print("DEBUG: Cargo hold empty.")
			empty.text = "[H] Sell all"
			item_container.add_child(empty)
		else:
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

	# --- upgrades section ---
	var sep := Label.new()
	sep.text = "--- UPGRADES (press number to buy) ---"
	item_container.add_child(sep)

	var ids := ["speed", "thrust", "laser_damage", "laser_focus"]
	var num := 1
	for id in ids:
		var line := Label.new()
		var cost := GameState.upgrades.next_cost(id)
		var lvl_val := GameState.upgrades.get_value(id)
		var data = UpgradeData.UPGRADES[id]
		if cost < 0:
			line.text = "[%d] %s: MAXED (%s)" % [num, data["name"], str(lvl_val)]
		else:
			line.text = "[%d] %s: %s  ->  ₴%d" % [num, data["name"], str(lvl_val), cost]
		item_container.add_child(line)
		num += 1

func _buy_upgrade(id: String) -> void:
	if GameState.try_buy_upgrade(id):
		print("bought ", id, " -> ", GameState.upgrades.get_value(id))
	else:
		print("can't buy ", id, " (maxed or too poor)")
	_refresh_list()

func _price_of(item: CargoItem) -> float:
	return item.sell_value(GameState.market)

func _on_sell(entry: String, price: float) -> void:
	if player_ref and player_ref.has_method("remove_from_inventory"):
		player_ref.remove_from_inventory(entry)
	GameState.sell(price)
	print("SOLD ", entry, " for ₴", price)
	_refresh_list()

func _sell_everything() -> void:
	if player_ref == null:
		player_ref = get_tree().get_first_node_in_group("player")
	if player_ref == null or not player_ref.has_method("return_inventory"):
		print("H: no player / no inventory")
		return
	for entry in player_ref.return_inventory().duplicate():
		var item := CargoItem.from_reward(entry)
		if item == null:
			continue
		var price := _price_of(item)
		if player_ref.has_method("remove_from_inventory"):
			player_ref.remove_from_inventory(entry)
		GameState.sell(price)
		print("SOLD ", entry, " for ₴", price)
	if visible:
		_refresh_list()
	print("H: sold everything. money now ₴", GameState.money)
