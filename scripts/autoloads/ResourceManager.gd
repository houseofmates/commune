class_name ResourceManager
extends Node

var tick_timer: Timer
var save_timer: float = 0.0

func _ready() -> void:
	tick_timer = Timer.new()
	tick_timer.wait_time = 1.0
	tick_timer.autostart = true
	tick_timer.timeout.connect(_on_tick)
	add_child(tick_timer)

func _process(delta: float) -> void:
	save_timer += delta
	if save_timer >= 60.0:
		save_timer = 0.0
		SaveManager.save_game()

func _on_tick() -> void:
	update_production_rates()

	# Calculate production scale based on available resources for consumption
	var production_scale: float = 1.0
	for res_id in GameState.resources.keys():
		var rate = GameState.production_rates.get(res_id, 0.0)
		if rate < 0:  # Consumption
			var required = abs(rate)
			var available = GameState.resources[res_id]
			var available_fraction = 0.0 if required == 0 else clamp(available / required, 0.0, 1.0)
			production_scale = min(production_scale, available_fraction)

	# Skip production if no resources available
	if production_scale == 0:
		return

	# Apply scaled rates
	for res_id in GameState.resources.keys():
		var rate = GameState.production_rates.get(res_id, 0.0)
		if rate > 0:
			GameState.add_resource(res_id, floor(rate * production_scale))
		elif rate < 0:
			GameState.consume_resource(res_id, ceil(abs(rate) * production_scale))

func update_production_rates() -> void:
	for res_id in GameState.production_rates.keys():
		GameState.production_rates[res_id] = 1.0 if res_id == "labor_vouchers" else 0.0

	for b in GameState.buildings:
		if is_instance_valid(b):
			var efficiency = (b as BaseBuilding).get_efficiency()
			var prod = b.get_production()
			for res_id in prod.keys():
				GameState.production_rates[res_id] = GameState.production_rates.get(res_id, 0.0) + prod[res_id] * efficiency

			var cons = b.get_consumption()
			for res_id in cons.keys():
				GameState.production_rates[res_id] = GameState.production_rates.get(res_id, 0.0) - cons[res_id] * efficiency
