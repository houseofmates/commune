extends Control
class_name SettingsPanel

func _on_close_pressed() -> void:
	queue_free()

func _on_save_pressed() -> void:
	SaveManager.save_game()
	queue_free()

func _on_quit_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/TitleScreen.tscn")
