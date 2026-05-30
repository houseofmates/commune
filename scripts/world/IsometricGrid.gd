class_name IsometricGrid
extends TileMapLayer

const TILE_SIZE = Vector2i(64, 32)

func _ready() -> void:
	# Initialize grid bounds if needed
	pass

func world_to_tile(world_pos: Vector2) -> Vector2i:
	return local_to_map(to_local(world_pos))

func tile_to_world(tile_pos: Vector2i) -> Vector2:
	return to_global(map_to_local(tile_pos))
