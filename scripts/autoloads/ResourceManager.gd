extends Node
class_name ResourceManager

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
		var sm = get_tree().root.find_child("SaveManager", true, false)
		if sm: sm.save_game()

func _on_tick() -> void:
	update_production_rates()
	for res_id in GameState.resources.keys():
		var rate = GameState.production_rates.get(res_id, 0.0)
		if rate > 0:
			GameState.add_resource(res_id, rate)
		elif rate < 0:
			if GameState.resources[res_id] >= abs(rate):
				GameState.consume_resource(res_id, abs(rate))
			else:
				GameState.consume_resource(res_id, GameState.resources[res_id])

func update_production_rates() -> void:
	for res_id in GameState.production_rates.keys():
		GameState.production_rates[res_id] = 1.0 if res_id == "labor_vouchers" else 0.0

	for b in GameState.buildings:
		if is_instance_valid(b):
			# BaseBuilding.get_production() and get_consumption() already include efficiency
			var prod = b.get_production()
			for res_id in prod.keys():
				GameState.production_rates[res_id] = GameState.production_rates.get(res_id, 0.0) + prod[res_id]

			var cons = b.get_consumption()
			for res_id in cons.keys():
				GameState.production_rates[res_id] = GameState.production_rates.get(res_id, 0.0) - cons[res_id]
