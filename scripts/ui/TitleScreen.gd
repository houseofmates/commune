extends Control
class_name TitleScreen

func _ready() -> void:
	if not FileAccess.file_exists(SaveManager.SAVE_PATH):
		$VBox/ContinueButton.disabled = true

func _on_new_game_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/Main.tscn")

func _on_continue_pressed() -> void:
	SaveManager.load_game()
	get_tree().change_scene_to_file("res://scenes/Main.tscn")

func _on_settings_pressed() -> void:
	var settings = load("res://scenes/ui/SettingsPanel.tscn").instantiate()
	add_child(settings)
