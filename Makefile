.PHONY: run export-android export-linux import

run:
	godot --path .

export-android:
	mkdir -p build/android
	godot --headless --path . --export-release "Android" build/android/the-commune.apk

export-linux:
	mkdir -p build/linux
	godot --headless --path . --export-release "Linux" build/linux/the-commune.AppImage

import:
	godot --headless --path . --editor --quit
