@tool
extends SceneTree

func _init():
	var assets = [
		"res://assets/sprites/character/john.png",
		"res://assets/sprites/buildings/house.png",
		"res://assets/sprites/buildings/farm.png",
		"res://assets/sprites/buildings/workshop.png",
		"res://assets/sprites/buildings/power_plant.png",
		"res://assets/sprites/buildings/library.png",
		"res://assets/sprites/buildings/meeting_hall.png",
		"res://assets/sprites/buildings/clinic.png",
		"res://assets/sprites/buildings/school.png",
		"res://assets/sprites/buildings/recreation_center.png",
		"res://assets/sprites/buildings/water_tower.png",
		"res://assets/sprites/resources/food.png",
		"res://assets/sprites/resources/energy.png",
		"res://assets/sprites/resources/materials.png",
		"res://assets/sprites/resources/knowledge.png",
		"res://assets/sprites/resources/labor_points.png",
		"res://assets/sprites/ui/button.png",
		"res://assets/sprites/ui/panel.png"
	]

	for path in assets:
		var dir = path.get_base_dir()
		if not DirAccess.dir_exists_absolute(dir):
			DirAccess.make_dir_recursive_absolute(dir)

		if not FileAccess.file_exists(path):
			var img = Image.create(32, 32, false, Image.FORMAT_RGBA8)
			img.fill(Color.WHITE)
			img.save_png(path)
			print("Generated: ", path)

	quit()
