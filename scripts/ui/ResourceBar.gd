extends HBoxContainer

func _ready() -> void:
	EventBus.resource_updated.connect(_on_resource_updated)
	# Initial update
	for res_id in GameState.resources.keys():
		_on_resource_updated(res_id, GameState.resources[res_id])

func _on_resource_updated(res_id: String, amount: float) -> void:
	var label = find_child(res_id.capitalize() + "Label", true, false)
	if label:
		label.text = str(int(amount))
