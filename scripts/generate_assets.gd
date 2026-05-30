extends Node

func _ready() -> void:
	_generate_all()
	get_tree().quit()

func _generate_all() -> void:
	for dir in [
		"assets/sprites/buildings",
		"assets/sprites/resources",
		"assets/sprites/ui",
		"assets/sprites/character"
	]:
		var err = DirAccess.make_dir_recursive_absolute(dir)
		if err != OK:
			push_error("Failed to create directory: " + dir)
			continue

	# Buildings
	var building_names = ["house", "farm", "workshop", "power_plant", "library", "meeting_hall", "clinic", "school", "recreation_center", "water_tower", "blacksmith", "smelter", "stonemason", "tailor", "monument"]
	for b in building_names:
		_gen_sprite("assets/sprites/buildings/" + b + ".png", Vector2i(64, 64), Color.DARK_GRAY)

	# Resources
	var resource_names = ["food", "energy", "materials", "knowledge", "labor_vouchers", "wood", "stone", "iron_ore", "iron_ingots", "cloth", "tools", "medicine", "culture", "water"]
	for r in resource_names:
		_gen_sprite("assets/sprites/resources/" + r + ".png", Vector2i(32, 32), Color.MEDIUM_PURPLE)

	# UI
	_gen_sprite("assets/sprites/ui/panel.png", Vector2i(128, 128), Color.WEB_GRAY)
	_gen_sprite("assets/sprites/ui/button.png", Vector2i(64, 64), Color.LIGHT_GRAY)

	# Character
	_gen_sprite("assets/sprites/character/john.png", Vector2i(32, 64), Color.SKY_BLUE)
	_gen_sprite("assets/sprites/character/worker.png", Vector2i(32, 64), Color.SANDY_BROWN)

func _gen_sprite(path: String, size: Vector2i, color: Color) -> void:
	var img = Image.create(size.x, size.y, false, Image.FORMAT_RGBA8)
	img.fill(color)
	var err = img.save_png(path)
	if err == OK:
		print("Generated: ", path)
	else:
		push_error("Failed to save sprite: " + path)
