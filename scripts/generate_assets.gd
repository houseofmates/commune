@tool
extends SceneTree

func _init():
	var assets = {
		"buildings/house.png": Color.GRAY,
		"buildings/farm.png": Color.GREEN,
		"buildings/workshop.png": Color.BROWN,
		"buildings/power_plant.png": Color.YELLOW,
		"buildings/library.png": Color.BLUE,
		"buildings/foresters_hut": Color.DARK_GREEN,
		"buildings/quarry.png": Color.DIM_GRAY,
		"buildings/mine.png": Color.SADDLE_BROWN,
		"buildings/sheep_farm.png": Color.WHITE,
		"buildings/mill.png": Color.WHEAT,
		"buildings/sawmill.png": Color.SIENNA,
		"buildings/stonemason.png": Color.LIGHT_GRAY,
		"buildings/smelter.png": Color.DARK_SLATE_GRAY,
		"buildings/bakery.png": Color.PERU,
		"buildings/blacksmith.png": Color.DARK_CYAN,
		"buildings/tailor.png": Color.VIOLET,
		"buildings/monument.png": Color.GOLD,
		"resources/labor_vouchers.png": Color.GOLD,
		"resources/wheat.png": Color.GOLDENROD,
		"resources/logs.png": Color.SADDLE_BROWN,
		"resources/stone.png": Color.GRAY,
		"resources/iron_ore.png": Color.CHOCOLATE,
		"resources/flour.png": Color.WHITE,
		"resources/planks.png": Color.SANDY_BROWN,
		"resources/stone_blocks.png": Color.SILVER,
		"resources/iron_ingots.png": Color.LIGHT_STEEL_BLUE,
		"resources/bread.png": Color.SADDLE_BROWN,
		"resources/furniture.png": Color.BURLYWOOD,
		"resources/tools.png": Color.DARK_GRAY,
		"resources/wool.png": Color.SNOW,
		"resources/clothing.png": Color.ROYAL_BLUE,
		"ui/button.png": Color.LIGHT_GRAY,
		"ui/panel.png": Color.DARK_GRAY
	}

	# Delete existing sprites
	var base_path = "res://assets/sprites/"
	_delete_recursive(base_path)

	for path in assets.keys():
		var full_path = base_path + path
		if not full_path.ends_with(".png"):
			full_path += ".png"

		var dir = full_path.get_base_dir()
		if not DirAccess.dir_exists_absolute(dir):
			var err = DirAccess.make_dir_recursive_absolute(dir)
			if err != OK:
				push_error("Failed to create directory: " + dir)
				continue

		var img = Image.create(32, 32, false, Image.FORMAT_RGBA8)
		img.fill(assets[path])

		# Draw a simple shape or letter
		var rect = Rect2i(8, 8, 16, 16)
		img.fill_rect(rect, assets[path].darkened(0.5))

		var err = img.save_png(full_path)
		if err == OK:
			pass
		else:
			push_error("Failed to save PNG: " + full_path)

	quit()

func _delete_recursive(path: String):
	var dir = DirAccess.open(path)
	if dir:
		dir.list_dir_begin()
		var file_name = dir.get_next()
		while file_name != "":
			if file_name != "." and file_name != "..":
				if dir.current_is_dir():
					_delete_recursive(path + "/" + file_name)
				else:
					dir.remove(file_name)
			file_name = dir.get_next()
		dir.list_dir_end()
