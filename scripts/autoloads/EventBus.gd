extends Node

# UI Signals
signal building_selected(building_data: Dictionary)
signal build_requested(building_id: String, position: Vector2)

# Game Signals
signal resource_updated(resource_id: String, amount: float)
signal building_placed(building: Node)
signal building_upgraded(building: Node)

# Character Signals
signal character_interacted(building: Node)
