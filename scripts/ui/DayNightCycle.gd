extends ColorRect

@export var cycle_duration: float = 300.0 # 5 minutes

func _process(_delta: float) -> void:
	var time = fmod(Time.get_unix_time_from_system(), cycle_duration)
	var progress = time / cycle_duration

	# 0.0 to 1.0 cycle: Day -> Night -> Day
	# We use a sine wave to transition
	var intensity = (sin(progress * TAU - PI/2) + 1.0) / 2.0
	# intensity 0 = Day, 1 = Night

	modulate = Color(0.0, 0.0, 0.4, intensity * 0.4)
