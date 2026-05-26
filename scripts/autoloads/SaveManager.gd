extends Node

const SAVE_PATH = "user://commune_save.json"

func _ready() -> void:
	# In a real game we would auto-load here
	pass

func save_game() -> void:
	var save_data = {
		"resources": GameState.resources,
		"buildings": [],
		"last_save_time": Time.get_unix_time_from_system()
	}

	# Pack building data
	for b in GameState.buildings:
		save_data["buildings"].append({
			"id": b.id,
			"level": b.level,
			"position": {"x": b.position.x, "y": b.position.y}
		})

	var file = FileAccess.open(SAVE_PATH, FileAccess.WRITE)
	if file:
		file.store_string(JSON.stringify(save_data))
		print("Game saved to ", SAVE_PATH)

func load_game() -> void:
	if not FileAccess.file_exists(SAVE_PATH):
		return

	var file = FileAccess.open(SAVE_PATH, FileAccess.READ)
	var json = JSON.parse_string(file.get_as_text())

	if json:
		GameState.resources = json.get("resources", GameState.resources)
		GameState.last_save_time = json.get("last_save_time", Time.get_unix_time_from_system())
		# Actual building instantiation would happen in World.gd
		# but we store the data in GameState for now
		GameState.buildings = json.get("buildings", [])

		calculate_offline_gains()

func calculate_offline_gains() -> void:
	var current_time = Time.get_unix_time_from_system()
	var diff = current_time - GameState.last_save_time
	if diff > 0:
		print("Calculating offline gains for ", diff, " seconds")
		# We'll need the ResourceManager to handle the actual tick logic
		# But we can do a simple version here or call into it
		for res_id in GameState.resources.keys():
			var rate = GameState.production_rates.get(res_id, 0.0)
			GameState.add_resource(res_id, rate * diff)
