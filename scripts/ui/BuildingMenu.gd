extends Control
class_name BuildingMenu

@onready var container: GridContainer = $Panel/ScrollContainer/GridContainer
@onready var panel: Panel = $Panel

func _ready() -> void:
	visible = false
	modulate.a = 0
	populate_menu()

func populate_menu() -> void:
	var buildings = GameState.get_building_data()
	for b in buildings:
		var btn = Button.new()
		btn.text = b["display_name"].to_lower() + "\n(" + str(b["cost"].get("labor_vouchers", 0)) + " lv)"
		btn.custom_minimum_size = Vector2(100, 100)
		btn.theme_override_fonts/font = load("res://assets/fonts/VarelaRound-Regular.ttf")
		btn.theme_override_font_sizes/font_size = 12
		btn.pressed.connect(_on_building_selected.bind(b))
		btn.button_down.connect(_on_button_down.bind(btn))
		btn.button_up.connect(_on_button_up.bind(btn))
		container.add_child(btn)

func _on_button_down(btn: Button) -> void:
	var tween = create_tween()
	tween.tween_property(btn, "scale", Vector2(0.98, 0.98), 0.1)

func _on_button_up(btn: Button) -> void:
	var tween = create_tween()
	tween.tween_property(btn, "scale", Vector2.ONE, 0.1)

func _on_building_selected(b_data: Dictionary) -> void:
	var unlocked = GameState.get_resource_amount("labor_vouchers") >= b_data.get("unlock_at_labor_vouchers", 0)
	if not unlocked: return

	if GameState.consume_resource("labor_vouchers", b_data["cost"].get("labor_vouchers", 0)):
		# In a real game we would enter placement mode
		# For now we'll send a position in the center
		var center = get_viewport_rect().size / 2
		EventBus.build_requested.emit(b_data["id"], center)
		toggle()

func toggle() -> void:
	var tween = create_tween()
	tween.set_parallel(true)
	tween.set_ease(Tween.EASE_OUT)
	tween.set_trans(Tween.TRANS_CUBIC)

	if visible:
		tween.tween_property(self, "modulate:a", 0.0, 0.2)
		tween.tween_property(panel, "scale", Vector2(0.9, 0.9), 0.2)
		await tween.finished
		visible = false
	else:
		visible = true
		panel.scale = Vector2(0.9, 0.9)
		tween.tween_property(self, "modulate:a", 1.0, 0.3)
		tween.tween_property(panel, "scale", Vector2.ONE, 0.3)
