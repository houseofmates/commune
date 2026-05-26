extends Control

@onready var building_menu: Control = $BuildingMenu
@onready var build_button: Button = $BuildButton
@onready var worker_count: Label = $WorkerCount

func _ready() -> void:
	build_button.button_down.connect(_on_button_down.bind(build_button))
	build_button.button_up.connect(_on_button_up.bind(build_button))

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
	tween.tween_property(btn, "scale", Vector2.ONE, 0.1)

func _on_build_button_pressed() -> void:
	building_menu.toggle()
