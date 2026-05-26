extends Node

const SAVE_PATH = "user://commune_save.json"

func save_game() -> void:
	EventBus.save_triggered.emit()
	# Preserve existing tutorial state if available
	var existing_tutorial_complete = false
	if FileAccess.file_exists(SAVE_PATH):
		var existing_file = FileAccess.open(SAVE_PATH, FileAccess.READ)
		if existing_file:
			var existing_json = JSON.parse_string(existing_file.get_as_text())
			if existing_json and existing_json is Dictionary:
				existing_tutorial_complete = existing_json.get("tutorial_complete", false)

	var save_data = {
		"resources": GameState.resources,
		"buildings": [],
		"last_save_time": Time.get_unix_time_from_system(),
		"total_workers": GameState.total_workers,
		"assigned_workers": GameState.assigned_workers,
		"tutorial_complete": existing_tutorial_complete
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
		var buildings = json.get("buildings", [])
		if not (buildings is Array):
			push_warning("SaveManager: buildings data is not an Array, using empty array")
			buildings = []
		GameState.pending_building_data = buildings

		# Offline gains calculated after rehydration in World or Main

func calculate_offline_gains() -> void:
	var current_time = Time.get_unix_time_from_system()
	var time_elapsed = current_time - GameState.last_save_time

	# Cap offline time to 24 hours to prevent exploits
	time_elapsed = min(time_elapsed, 86400)

	if time_elapsed <= 0:
		return

	# Calculate offline production based on production rates
	for resource_id in GameState.production_rates.keys():
		var production_rate = GameState.production_rates[resource_id]
		if production_rate > 0:
			var offline_gain = production_rate * time_elapsed
			GameState.add_resource(resource_id, offline_gain)

	GameState.last_save_time = current_time
