extends CanvasLayer
class_name TutorialOverlay

var steps = [
	{"text": "drag anywhere to move", "pos": Vector2(0.5, 0.5)},
	{"text": "tap buildings to manage them", "pos": Vector2(0.5, 0.4)},
	{"text": "open the build menu to expand", "pos": Vector2(0.8, 0.9)}
]
var current_step = 0

@onready var panel: Panel = $Panel
@onready var label: Label = $Panel/Label

func _ready() -> void:
	if GameState.tutorial_complete:
		queue_free()
		return
	_update_step()

func _input(event: InputEvent) -> void:
	if event is InputEventScreenTouch and event.pressed:
		current_step += 1
		if current_step >= steps.size():
			GameState.tutorial_complete = true
			var sm = get_node_or_null("/root/SaveManager")
			if sm: sm.save_game()

			var file = FileAccess.open("user://tutorial_done.txt", FileAccess.WRITE)
			if file:
				file.store_string("done")
			else:
				push_warning("TutorialOverlay: Failed to save completion state")

			queue_free()
		else:
			_update_step()

func _update_step() -> void:
	var step = steps[current_step]
	label.text = step["text"].to_lower()
	panel.anchor_left = step["pos"].x - 0.2
	panel.anchor_right = step["pos"].x + 0.2
	panel.anchor_top = step["pos"].y - 0.1
	panel.anchor_bottom = step["pos"].y + 0.1
