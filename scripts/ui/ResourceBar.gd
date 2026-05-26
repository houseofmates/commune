extends HBoxContainer
class_name ResourceBar

func _ready() -> void:
	EventBus.resource_updated.connect(_on_resource_updated)
	for res_id in GameState.resources.keys():
		_on_resource_updated(res_id, GameState.resources[res_id])

func _on_resource_updated(res_id: String, amount: float) -> void:
	var label_name = ""
	match res_id:
		"bread": label_name = "FoodLabel"
		"labor_vouchers": label_name = "LaborPointsLabel"

	var label = find_child(label_name, true, false)
	if label:
		label.text = str(int(amount))
		_animate_change(label)

func _animate_change(node: Control) -> void:
	var tween = create_tween()
	tween.set_parallel(true)
	tween.tween_property(node, "scale", Vector2(1.1, 1.1), 0.15)
	tween.tween_property(node, "modulate", Color.WHITE, 0.15).from(Color.YELLOW)

	tween.chain()
	tween.set_parallel(true)
	tween.tween_property(node, "scale", Vector2(1.0, 1.0), 0.15)
	tween.tween_property(node, "modulate", Color.WHITE, 0.15)
