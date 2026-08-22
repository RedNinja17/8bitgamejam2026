extends CanvasLayer

var player_ref: Node2D = null

@onready var item_container: VBoxContainer = $PanelContainer/VBoxContainer/ScrollContainer/ItemListContainer
@onready var title_label: Label = $PanelContainer/VBoxContainer/Title
@onready var analyze_btn: Button = $PanelContainer/VBoxContainer/Analyze
@onready var sell_btn: Button = $PanelContainer/VBoxContainer/Sell
@onready var close_btn: Button = $PanelContainer/VBoxContainer/Close

func setup_shop(player: Node2D) -> void:
	player_ref = player
	close_btn.pressed.connect(queue_free)
	#sell_all_btn.pressed.connect(_on_sell_all_pressed)
	#refresh_inventory_list()


func calculate_asteriod_list() -> float:
	Array suppply = player.return_inventory(); 
	for index in supply:
		for part in index.split("_"):
			var row := HBoxContainer.new()
			
			var label := Label.new()
			label.text = item_name + " - Value: $" + str(item_price)
			label.size_flags_horizontal = Control.SIZE_EXPAND_FILL
			row.add_child(label)
			
			var sell_button := Button.new()
			sell_button.text = "Sell"
			
			sell_button.pressed.connect(func(): sell(index, item_price))
			row.add_child(sell_button)
			
			item_container.add_child(row)
			
		
	
func _sell(index: int, item_price: float):
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
