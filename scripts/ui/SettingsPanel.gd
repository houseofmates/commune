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
	var confirm = ConfirmationDialog.new()
	confirm.dialog_text = "are you sure? this cannot be undone."
	confirm.get_ok_button().text = "erase save"
	confirm.get_cancel_button().text = "cancel"
	confirm.confirmed.connect(_do_erase)
	add_child(confirm)
	confirm.popup_centered()

func _do_erase() -> void:
	DirAccess.remove_absolute(SaveManager.SAVE_PATH)
	get_tree().quit()

func _on_close_pressed() -> void:
	queue_free()
