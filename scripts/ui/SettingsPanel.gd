extends CanvasLayer
class_name SettingsPanel

func _ready() -> void:
	$Panel/VBox/MasterSlider.value = db_to_linear(AudioServer.get_bus_volume_db(0))
	$Panel/VBox/SFXSlider.value = db_to_linear(AudioServer.get_bus_volume_db(AudioServer.get_bus_index("SFX")))
	$Panel/VBox/MusicSlider.value = db_to_linear(AudioServer.get_bus_volume_db(AudioServer.get_bus_index("Music")))

func _on_master_slider_changed(value: float) -> void:
	AudioServer.set_bus_volume_db(0, linear_to_db(value))

func _on_sfx_slider_changed(value: float) -> void:
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("SFX"), linear_to_db(value))

func _on_music_slider_changed(value: float) -> void:
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Music"), linear_to_db(value))

func _on_erase_save_pressed() -> void:
	# Confirmation logic would go here
	DirAccess.remove_absolute("user://commune_save.json")
	get_tree().quit()

func _on_close_pressed() -> void:
	queue_free()
