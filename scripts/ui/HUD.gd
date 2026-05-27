extends Control
class_name HUD

@onready var building_menu: BuildingMenu = $BuildingMenu
@onready var build_button: Button = $BuildButton
@onready var worker_count: Label = $WorkerCount
@onready var save_icon: Label = $SaveIcon

func _ready() -> void:
	build_button.button_down.connect(_on_button_down.bind(build_button))
	build_button.button_up.connect(_on_button_up.bind(build_button))
	EventBus.save_triggered.connect(_on_save_triggered)

func _process(_delta: float) -> void:
	worker_count.text = "workers: " + str(GameState.assigned_workers) + "/" + str(GameState.total_workers)

func _on_button_down(btn: Button) -> void:
	var tween = create_tween()
	tween.set_ease(Tween.EASE_OUT)
	tween.set_trans(Tween.TRANS_CUBIC)
	tween.tween_property(btn, "scale", Vector2(0.98, 0.98), 0.1)

func _on_button_up(btn: Button) -> void:
	var tween = create_tween()
	tween.set_ease(Tween.EASE_OUT)
	tween.set_trans(Tween.TRANS_CUBIC)
	tween.tween_property(btn, "scale", Vector2(1.0, 1.0), 0.1)

func _on_build_button_pressed() -> void:
	AudioManager.play_click()
	building_menu.toggle()

func _on_settings_button_pressed() -> void:
	AudioManager.play_click()
	var settings = load("res://scenes/ui/SettingsPanel.tscn").instantiate()
	add_child(settings)

func _on_save_triggered() -> void:
	save_icon.visible = true
	await get_tree().create_timer(2.0).timeout
	save_icon.visible = false
