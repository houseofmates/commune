extends Node

# UI Signals
signal building_selected(building_data: Dictionary)
signal build_requested(building_id: String, cost: Dictionary)
signal toggle_build_menu()
signal workers_need_sync()

# Game Signals
signal resource_updated(resource_id: String, amount: float)
signal resource_gained_at(res_id: String, amount: float, pos: Vector2)
signal building_placed(building: Node)
signal building_upgraded(building: Node)
signal monument_completed(pos: Vector2)
signal save_triggered()

# Character Signals
signal character_interacted(building: Node)
