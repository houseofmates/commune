extends Node2D
class_name SimpleParticles

func _ready():
	for i in range(8):
		var rect = ColorRect.new()
		rect.size = Vector2(4, 4)
		rect.color = Color.GOLD
		add_child(rect)
		var dir = Vector2.RIGHT.rotated(randf() * TAU)
		var tween = create_tween()
		tween.tween_property(rect, "position", dir * 40.0, 0.5)
		tween.parallel().tween_property(rect, "modulate:a", 0.0, 0.5)

	get_tree().create_timer(0.6).timeout.connect(queue_free)
