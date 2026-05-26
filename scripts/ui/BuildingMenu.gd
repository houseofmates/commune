extends Control

@onready var container: VBoxContainer = $Panel/ScrollContainer/VBoxContainer
@onready var panel: Panel = $Panel

func _ready() -> void:
	visible = false
	modulate.a = 0
	populate_menu()

func populate_menu() -> void:
	var buildings = GameState.get_building_data()
	for b in buildings:
		var btn = Button.new()
		btn.text = "%s (%d lp)" % [b["display_name"].to_lower(), b["cost"].get("labor_points", 0)]
		btn.custom_minimum_size = Vector2(0, 48)
		btn.theme_override_fonts/font = load("res://assets/fonts/VarelaRound-Regular.ttf")
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
	EventBus.build_requested.emit(b_data["id"], Vector2.ZERO)
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
