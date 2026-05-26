extends BaseBuilding
class_name Monument

var completion_time: float = 600.0 # 10 minutes
var current_build_time: float = 0.0
var is_completed: bool = false

func _ready() -> void:
	super._ready()
	if level > 1:
		is_completed = true

func _process(delta: float) -> void:
	if not is_completed and level == 1:
		current_build_time += delta
		if current_build_time >= completion_time:
			complete_monument()

func complete_monument() -> void:
	is_completed = true
	# Show victory scroll
	var scroll = Label.new()
	scroll.text = "Congratulations!\nYou have built the Monument to Labour.\n\nThe collective thrives.\n\nCredits:\nYou & The People"
	scroll.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	var canvas = CanvasLayer.new()
	canvas.add_child(scroll)
	get_tree().root.add_child(canvas)
	# In a real game we'd animate this.
