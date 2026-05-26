extends Node

var tick_timer: Timer

func _ready() -> void:
	tick_timer = Timer.new()
	tick_timer.wait_time = 1.0
	tick_timer.autostart = true
	tick_timer.timeout.connect(_on_tick)
	add_child(tick_timer)

func _on_tick() -> void:
	# 1. Update global production rates based on buildings
	update_production_rates()

	# 2. Apply production
	for res_id in GameState.resources.keys():
		var rate = GameState.production_rates.get(res_id, 0.0)
		if rate > 0:
			GameState.add_resource(res_id, rate)
		elif rate < 0:
			# Only consume if we have enough
			if GameState.resources[res_id] >= abs(rate):
				GameState.consume_resource(res_id, abs(rate))
			else:
				# If we can't consume, maybe disable the building or reduce production?
				# For now, we'll just allow it to go to 0
				GameState.consume_resource(res_id, GameState.resources[res_id])

	# 3. Handle auto-save
	if int(Time.get_unix_time_from_system()) % 60 == 0:
		SaveManager.save_game()

func update_production_rates() -> void:
	# Reset rates to base
	for res_id in GameState.production_rates.keys():
		GameState.production_rates[res_id] = 1.0 if res_id == "labor_vouchers" else 0.0

	# Sum up from all active buildings
	for b in GameState.buildings:
		if is_instance_valid(b):
			var efficiency = b.get_efficiency()
			var prod = b.get_production()
			for res_id in prod.keys():
				GameState.production_rates[res_id] = GameState.production_rates.get(res_id, 0.0) + prod[res_id] * efficiency

			var cons = b.get_consumption()
			for res_id in cons.keys():
				GameState.production_rates[res_id] = GameState.production_rates.get(res_id, 0.0) - cons[res_id] * efficiency
