extends HBoxContainer
class_name ResourceBar

var labels: Dictionary = {}

func _ready() -> void:
	# Clear initial placeholders
	for child in get_children():
		child.queue_free()

	# Populate based on all resources in GameState
	for res_id in GameState.resources.keys():
		_create_resource_label(res_id)

	EventBus.resource_updated.connect(_on_resource_updated)

func _create_resource_label(res_id: String) -> void:
	var label = Label.new()
	# Convention: lowercase internal names
	label.name = res_id.to_lower() + "label"
	add_child(label)
	labels[res_id] = label
	_update_label_text(res_id, GameState.resources[res_id])

func _on_resource_updated(res_id: String, amount: float) -> void:
	if not labels.has(res_id):
		_create_resource_label(res_id)

	_update_label_text(res_id, amount)
	_animate_change(labels[res_id])

func _update_label_text(res_id: String, amount: float) -> void:
	var label = labels.get(res_id)
	if not label: return
	label.text = res_id.replace("_", " ").to_lower() + ": " + str(int(amount))

func _animate_change(node: Control) -> void:
	if not node: return
	var tween = create_tween()
	tween.set_parallel(true)
	tween.tween_property(node, "scale", Vector2(1.1, 1.1), 0.15)
	tween.tween_property(node, "modulate", Color.YELLOW, 0.15)

	tween.chain()
	tween.set_parallel(true)
	tween.tween_property(node, "scale", Vector2.ONE, 0.15)
	tween.tween_property(node, "modulate", Color.WHITE, 0.15)
