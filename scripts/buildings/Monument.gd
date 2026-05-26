extends "res://scripts/buildings/BaseBuilding.gd"

func _ready():
	id = "monument"
	super._ready()

func upgrade() -> bool:
	var result = super.upgrade()
	if result:
		# Show victory message
		print("victory achieved!")
	return result
