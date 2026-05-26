extends Control

@onready var building_menu: Control = $BuildingMenu

func _on_build_button_pressed() -> void:
	building_menu.toggle()
