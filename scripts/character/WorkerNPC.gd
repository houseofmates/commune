extends CharacterBody2D
class_name WorkerNPC

@export var speed: float = 100.0
@export var visuals_path: NodePath = "Visuals"
@export var animation_player_path: NodePath = "AnimationPlayer"
@export var status_icon_path: NodePath = "StatusIcon"

@onready var visuals: Node2D = get_node_or_null(visuals_path)
@onready var animation_player: AnimationPlayer = get_node_or_null(animation_player_path)
@onready var status_icon: ColorRect = get_node_or_null(status_icon_path)

var assigned_building: BaseBuilding = null
var current_target_node: Node2D = null
var gathering_timer: float = 0.0
var gathering_duration: float = 2.0

enum State { IDLE, GATHERING, DELIVERING }
var current_state = State.IDLE

func _ready() -> void:
	if status_icon:
		status_icon.visible = true
	_update_visuals()

func assign_to(building: BaseBuilding) -> void:
	assigned_building = building
	current_state = State.GATHERING
	_find_nearest_resource()

func _update_visuals() -> void:
	if not status_icon: return
	match current_state:
		State.IDLE: status_icon.color = Color.TRANSPARENT
		State.GATHERING: status_icon.color = Color.GREEN
		State.DELIVERING: status_icon.color = Color.BLUE

func _get_needed_res() -> String:
	if not assigned_building: return ""
	if assigned_building.id == "farm": return "wheat"
	elif assigned_building.id == "foresters_hut": return "logs"
	elif assigned_building.id == "quarry": return "stone"
	elif assigned_building.id == "mine": return "iron_ore"
	elif assigned_building.id == "sheep_farm": return "wool"
	return ""

func _find_nearest_resource() -> void:
	var needed_res = _get_needed_res()
	if needed_res == "":
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
		if animation_player:
			animation_player.play("idle")

		if current_state == State.GATHERING:
			gathering_timer += delta
			if gathering_timer >= gathering_duration:
				gathering_timer = 0
				current_state = State.DELIVERING
				current_target_node = assigned_building
				_update_visuals()
		elif current_state == State.DELIVERING:
			EventBus.resource_gained_at.emit(_get_needed_res(), 1.0, global_position)
			current_state = State.GATHERING
			_find_nearest_resource()
			_update_visuals()
	else:
		var dir = (current_target_node.global_position - global_position).normalized()
		velocity = dir * speed
		if visuals and dir.x != 0:
			visuals.scale.x = -1 if dir.x < 0 else 1
		if animation_player:
			animation_player.play("walk")
		move_and_slide()
