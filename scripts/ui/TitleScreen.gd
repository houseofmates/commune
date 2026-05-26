extends Control

func _ready() -> void:
	# Check for existing save
	if not FileAccess.file_exists("user://commune_save.json"):
		$VBoxContainer/ContinueButton.disabled = true

func _on_new_game_pressed() -> void:
	# Show intro text first
	$IntroText.visible = true
	$VBoxContainer.visible = false

func _on_continue_pressed() -> void:
	SaveManager.load_game()
	get_tree().change_scene_to_file("res://scenes/Main.tscn")

func _on_settings_pressed() -> void:
	$SettingsPanel.visible = true

func _on_start_game_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/Main.tscn")

func _on_erase_save_pressed() -> void:
	DirAccess.remove_absolute("user://commune_save.json")
	$VBoxContainer/ContinueButton.disabled = true
	$SettingsPanel.visible = false
