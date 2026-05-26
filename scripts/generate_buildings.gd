@tool
extends SceneTree

func _init():
	var buildings = {
		"house": {"color": Color.GRAY, "abbr": "H"},
		"farm": {"color": Color.GREEN, "abbr": "F"},
		"workshop": {"color": Color.BROWN, "abbr": "W"},
		"power_plant": {"color": Color.YELLOW, "abbr": "P"},
		"library": {"color": Color.BLUE, "abbr": "L"},
		"meeting_hall": {"color": Color.RED, "abbr": "MH"},
		"clinic": {"color": Color.WHITE, "abbr": "C"},
		"school": {"color": Color.CYAN, "abbr": "S"},
		"recreation_center": {"color": Color.MAGENTA, "abbr": "R"},
		"water_tower": {"color": Color.DARK_BLUE, "abbr": "WT"}
	}

	for id in buildings.keys():
		var path = "res://assets/sprites/buildings/" + id + ".png"
		var img = Image.create(64, 64, false, Image.FORMAT_RGBA8)
		img.fill(buildings[id]["color"])

		# In a real tool we'd draw text here.
		# For now we'll just use the distinct colors since I can't easily draw text on Image in headless without a font loaded.

		var err = img.save_png(path)
		if err == OK:
			print("Generated building: ", path)

	quit()
