extends Control

@onready var container: VBoxContainer = $Panel/ScrollContainer/VBoxContainer

func _ready() -> void:
	visible = false
	populate_menu()

func populate_menu() -> void:
	var buildings = GameState.get_building_data()
	for b in buildings:
		var btn = Button.new()
		btn.text = "%s (%d LP)" % [b["display_name"], b["cost"].get("labor_points", 0)]
		btn.custom_minimum_size = Vector2(0, 48)
		btn.pressed.connect(_on_building_selected.bind(b))
		container.add_child(btn)

func _on_building_selected(b_data: Dictionary) -> void:
	EventBus.build_requested.emit(b_data["id"], Vector2.ZERO)
	visible = false

func toggle() -> void:
	visible = !visible
