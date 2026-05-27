extends Node

# UI Signals
signal building_selected(building_data: Dictionary)
signal build_requested(building_id: String, position: Vector2)
signal toggle_build_menu()

# Game Signals
signal resource_updated(resource_id: String, amount: float)
signal building_placed(building: Node)
signal building_upgraded(building: Node)
signal save_triggered()
signal monument_completed(pos: Vector2)

# Character Signals
signal character_interacted(building: Node)

signal resource_gained_at(res_id: String, amount: float, pos: Vector2)

signal workers_need_sync()
