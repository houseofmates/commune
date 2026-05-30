extends Node
class_name AudioManager

func set_volume(bus_name: String, value: float) -> void:
	var bus_index = AudioServer.get_bus_index(bus_name)
	if bus_index == -1: return
	var db = linear_to_db(value)
	AudioServer.set_bus_volume_db(bus_index, db)
