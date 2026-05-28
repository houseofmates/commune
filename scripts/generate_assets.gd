@tool
extends SceneTree

func _init():
	var buildings = ["house", "farm", "workshop", "foresters_hut", "quarry", "mine", "sheep_farm", "mill", "sawmill", "stonemason", "smelter", "bakery", "blacksmith", "tailor", "monument"]
	var resources = ["labor_vouchers", "wheat", "logs", "stone", "iron_ore", "flour", "planks", "stone_blocks", "iron_ingots", "bread", "furniture", "tools", "wool", "clothing"]

	var base_path = "res://assets/sprites/"

	print("WARNING: This tool will regenerate assets. Proceed? (Not actually prompting in headless)")

	# Create directories if they don't exist
	for dir_name in ["buildings", "resources", "ui", "character"]:
		var dir = base_path + dir_name
		if not DirAccess.dir_exists_absolute(dir):
			DirAccess.make_dir_recursive_absolute(dir)

	# Generate buildings
	for i in range(buildings.size()):
		var b = buildings[i]
		var color = Color.from_hsv(float(i) / buildings.size(), 0.7, 0.8)
		_generate_image(base_path + "buildings/" + b + ".png", color, b.substr(0, 1).to_upper())

	# Generate resources
	for i in range(resources.size()):
		var r = resources[i]
		var color = Color.from_hsv(float(i) / resources.size(), 0.5, 0.9)
		_generate_image(base_path + "resources/" + r + ".png", color, r.substr(0, 1).to_lower())

	# UI and Character
	_generate_image(base_path + "ui/button.png", Color.DARK_GRAY, "B")
	_generate_image(base_path + "ui/panel.png", Color.BLACK, "P")
	_generate_image(base_path + "character/john.png", Color.SADDLE_BROWN, "J")

	quit()

func _generate_image(path: String, color: Color, label: String):
	# Only overwrite if file doesn't exist or is intended for regeneration
	# For now we'll just log and save to be safe
	var img = Image.create(32, 32, false, Image.FORMAT_RGBA8)
	img.fill(color)

	# pattern
	for x in range(32):
		img.set_pixel(x, 0, Color.BLACK)
		img.set_pixel(x, 31, Color.BLACK)
	for y in range(32):
		img.set_pixel(0, y, Color.BLACK)
		img.set_pixel(31, y, Color.BLACK)

	for i in range(8, 24):
		img.set_pixel(i, i, Color.WHITE)
		img.set_pixel(31-i, i, Color.WHITE)

	var err = img.save_png(path)
	if err == OK:
		print("Generated/Updated: ", path)
	else:
		push_error("Failed to save: " + path)
