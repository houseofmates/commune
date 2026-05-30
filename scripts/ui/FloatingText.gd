extends Label
class_name FloatingText

func _ready() -> void:
	theme_override_colors/font_color = Color.GOLD
	horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER

	var tween = create_tween()
	tween.tween_property(self, "position:y", position.y - 50, 1.0)
	tween.parallel().tween_property(self, "modulate:a", 0.0, 1.0)
	await tween.finished
	queue_free()
