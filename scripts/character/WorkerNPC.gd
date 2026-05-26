extends CharacterBody2D
class_name WorkerNPC

@export var speed: float = 100.0
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var visuals: Node2D = $Visuals
@onready var status_icon: ColorRect = $StatusIcon

var assigned_building: BaseBuilding = null
var current_target_node: Node2D = null
var gathering_timer: float = 0.0
var gathering_duration: float = 2.0

enum State { IDLE, GATHERING, DELIVERING }
var current_state = State.IDLE

func _ready() -> void:
	status_icon.visible = true
	_update_visuals()

func assign_to(building: BaseBuilding) -> void:
	assigned_building = building
	current_state = State.GATHERING
	_find_nearest_resource()

func _update_visuals() -> void:
	match current_state:
		State.IDLE: status_icon.color = Color.TRANSPARENT
		State.GATHERING: status_icon.color = Color.GREEN
		State.DELIVERING: status_icon.color = Color.BLUE

func _find_nearest_resource() -> void:
	if not assigned_building: return

	# Determine needed resource based on building type
	var needed_res = ""
	if assigned_building.id == "farm": needed_res = "wheat"
	elif assigned_building.id == "foresters_hut": needed_res = "logs"
	elif assigned_building.id == "quarry": needed_res = "stone"
	elif assigned_building.id == "mine": needed_res = "iron_ore"
	elif assigned_building.id == "sheep_farm": needed_res = "wool"

	if needed_res == "":
		# Processing buildings just walk to the building itself or stay idle
		current_target_node = assigned_building
		return

	var targets = get_tree().get_nodes_in_group("worker_targets")
	var best_target = null
	var min_dist = INF

	for t in targets:
		if t is ResourceNode and t.resource_id == needed_res:
			var d = global_position.distance_to(t.global_position)
			if d < min_dist:
				min_dist = d
				best_target = t

	current_target_node = best_target

func _physics_process(delta: float) -> void:
	if not assigned_building:
		current_state = State.IDLE
		_update_visuals()
		return

	if current_target_node == null:
		_find_nearest_resource()
		if current_target_node == null: return

	var dist = global_position.distance_to(current_target_node.global_position)

	if dist < 20:
		velocity = Vector2.ZERO
		animation_player.play("idle")

		if current_state == State.GATHERING:
			gathering_timer += delta
			if gathering_timer >= gathering_duration:
				gathering_timer = 0
				current_state = State.DELIVERING
				current_target_node = assigned_building
				_update_visuals()
		elif current_state == State.DELIVERING:
			# Delivered
EventBus.resource_gained_at.emit("", 1.0, global_position)
			current_state = State.GATHERING
			_find_nearest_resource()
			_update_visuals()
	else:
		var dir = global_position.direction_to(current_target_node.global_position)
		velocity = dir * speed
		if dir.x != 0:
			visuals.scale.x = -1 if dir.x < 0 else 1
		animation_player.play("walk")
		move_and_slide()
