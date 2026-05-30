extends Control
class_name BuildingMenu

@onready var container: GridContainer = $Panel/ScrollContainer/GridContainer
@onready var panel: Panel = $Panel

var needs_refresh: bool = false

func _ready() -> void:
	visible = false
	modulate.a = 0
	EventBus.resource_updated.connect(_on_resource_updated)

func populate_menu() -> void:
	for child in container.get_children():
		child.queue_free()

	var buildings = GameState.get_building_data()
	var current_lv = GameState.get_resource_amount("labor_vouchers")

	for b in buildings:
		var unlock_lv = b.get("unlock_at_labor_vouchers", 0)
		var is_unlocked = current_lv >= unlock_lv

		var btn = Button.new()
		if is_unlocked:
			btn.text = b["display_name"].to_lower() + "\n(" + str(b["cost"].get("labor_vouchers", 0)) + " lv)"
			btn.pressed.connect(_on_building_selected.bind(b))
		else:
			btn.text = "locked\n(req: " + str(unlock_lv) + " lv)"
			btn.disabled = true
			btn.modulate = Color(0.5, 0.5, 0.5, 0.8)

		btn.custom_minimum_size = Vector2(100, 100)
		btn.add_theme_font_override("font", load("res://assets/fonts/VarelaRound-Regular.ttf"))
		btn.add_theme_font_size_override("font_size", 12)
		btn.button_down.connect(_on_button_down.bind(btn))
		btn.button_up.connect(_on_button_up.bind(btn))
		container.add_child(btn)

	needs_refresh = false

func _on_resource_updated(res_id: String, _amount: float) -> void:
	if res_id == "labor_vouchers":
		if visible:
			populate_menu()
		else:
			needs_refresh = true

func _on_button_down(btn: Button) -> void:
	var tween = create_tween()
	tween.tween_property(btn, "scale", Vector2(0.98, 0.98), 0.1)

func _on_button_up(btn: Button) -> void:
	var tween = create_tween()
	tween.tween_property(btn, "scale", Vector2(1.0, 1.0), 0.1)

func _on_building_selected(b_data: Dictionary) -> void:
	var center = get_viewport().get_visible_rect().size / 2.0
	var cost: Dictionary = b_data.get("cost", {})
	for res_id in cost.keys():
		if GameState.resources.get(res_id, 0) < cost[res_id]:
			return
	for res_id in cost.keys():
		GameState.consume_resource(res_id, cost[res_id])
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
		if needs_refresh or container.get_child_count() == 0:
			populate_menu()
		visible = true
		panel.scale = Vector2(0.9, 0.9)
		tween.tween_property(self, "modulate:a", 1.0, 0.3)
		tween.tween_property(panel, "scale", Vector2(1.0, 1.0), 0.3)
