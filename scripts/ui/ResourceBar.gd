extends HBoxContainer

func _ready() -> void:
	EventBus.resource_updated.connect(_on_resource_updated)
	# Initial update
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
