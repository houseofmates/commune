extends CanvasLayer

var tutorial_steps = [
	"drag to move comrade john.",
	"tap 'build' to expand the commune.",
	"manage buildings to assign workers."
]
var current_step = 0

func _ready() -> void:
	if not FileAccess.file_exists("user://tutorial_done.txt"):
		visible = true
		update_label()
	else:
		visible = false

func update_label() -> void:
	$Panel/Label.text = tutorial_steps[current_step]

func _on_next_pressed() -> void:
	current_step += 1
	if current_step < tutorial_steps.size():
		update_label()
	else:
		visible = false
		var file = FileAccess.open("user://tutorial_done.txt", FileAccess.WRITE)
		file.store_string("done")
