extends BaseBuilding
class_name Monument

var completion_time: float = 600.0 # 10 minutes
var current_build_time: float = 0.0
var is_completed: bool = false
var progress_bar: ProgressBar

func _ready() -> void:
	super._ready()
	if level > 1:
		is_completed = true

	progress_bar = ProgressBar.new()
	progress_bar.max_value = completion_time
	progress_bar.custom_minimum_size = Vector2(100, 10)
	progress_bar.position = Vector2(-50, -80)
	progress_bar.show_percentage = false
	add_child(progress_bar)

func _process(delta: float) -> void:
	if not is_completed and level == 1:
		current_build_time += delta
		progress_bar.value = current_build_time
		if current_build_time >= completion_time:
			complete_monument()

func complete_monument() -> void:
	is_completed = true
	level = 2
	progress_bar.visible = false

	EventBus.monument_completed.emit(global_position)

	# Screen Flash
	var flash = ColorRect.new()
	flash.color = Color.WHITE
	flash.anchors_preset = Control.PRESET_FULL_RECT
	var canvas = CanvasLayer.new()
	canvas.layer = 101
	canvas.add_child(flash)
	get_tree().root.add_child(canvas)

	var tween = create_tween()
	tween.tween_property(flash, "modulate:a", 0.0, 1.0)
	tween.tween_callback(canvas.queue_free)

	# Victory Panel
	var victory_canvas = CanvasLayer.new()
	victory_canvas.layer = 100
	get_tree().root.add_child(victory_canvas)

	var panel = Panel.new()
	panel.anchors_preset = Control.PRESET_FULL_RECT
	victory_canvas.add_child(panel)

	var title = Label.new()
	title.text = "monument to labour completed"
	title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	title.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	title.set_anchors_and_offsets_preset(Control.PRESET_CENTER_TOP, Control.PRESET_MODE_KEEP_SIZE, 50)
	panel.add_child(title)

	var credits = Label.new()
	credits.text = "the collective thrives.\n\nfrom each according to ability,\nto each according to need.\n\ncredits:\nyou & the people\ngodot engine\npkm aesthetic"
	credits.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	credits.set_anchors_and_offsets_preset(Control.PRESET_CENTER, Control.PRESET_MODE_KEEP_SIZE)
	panel.add_child(credits)

	var btn = Button.new()
	btn.text = "continue playing"
	btn.set_anchors_and_offsets_preset(Control.PRESET_CENTER_BOTTOM, Control.PRESET_MODE_KEEP_SIZE, -50)
	btn.pressed.connect(func(): victory_canvas.queue_free())
	panel.add_child(btn)
