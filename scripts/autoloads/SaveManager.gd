extends Node
class_name SaveManager

const SAVE_PATH = "user://commune_save.json"

func save_game() -> void:
	EventBus.save_triggered.emit()
	var save_data = {
		"resources": GameState.resources,
		"buildings": [],
		"last_save_time": Time.get_unix_time_from_system(),
		"total_workers": GameState.total_workers,
		"assigned_workers": GameState.assigned_workers,
		"tutorial_complete": GameState.tutorial_complete
	}

	for b in GameState.buildings:
		if is_instance_valid(b):
			save_data["buildings"].append({
				"id": b.id,
				"level": b.level,
				"position": {"x": b.global_position.x, "y": b.global_position.y},
				"assigned_workers": b.assigned_workers
			})

	var file = FileAccess.open(SAVE_PATH, FileAccess.WRITE)
	if file:
		file.store_string(JSON.stringify(save_data))

func load_game() -> void:
	if not FileAccess.file_exists(SAVE_PATH):
		return

	var file = FileAccess.open(SAVE_PATH, FileAccess.READ)
	var json = JSON.parse_string(file.get_as_text())

	if json:
		GameState.resources = json.get("resources", GameState.resources)
		GameState.last_save_time = json.get("last_save_time", Time.get_unix_time_from_system())
		GameState.pending_building_data = json.get("buildings", [])
		GameState.tutorial_complete = json.get("tutorial_complete", false)

func calculate_offline_gains() -> void:
	var current_time = Time.get_unix_time_from_system()
	var diff = current_time - GameState.last_save_time
	if diff > 0:
		for res_id in GameState.resources.keys():
			var rate = GameState.production_rates.get(res_id, 0.0)
			GameState.add_resource(res_id, rate * diff)
