extends Camera2D

@export var min_zoom: float = 0.5
@export var max_zoom: float = 2.0
@export var zoom_speed: float = 0.05
@export var lerp_weight: float = 0.1

var target_zoom: float = 1.0
var target_offset: Vector2 = Vector2.ZERO
var is_dragging: bool = false
var last_drag_pos: Vector2

@onready var character: Node2D = get_tree().root.find_child("Character", true, false)

func _ready() -> void:
	target_zoom = zoom.x

func _process(_delta: float) -> void:
	if character and not is_dragging:
		global_position = global_position.lerp(character.global_position, lerp_weight)

	zoom = zoom.lerp(Vector2.ONE * target_zoom, lerp_weight)

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_WHEEL_UP:
			target_zoom = clamp(target_zoom + zoom_speed, min_zoom, max_zoom)
		elif event.button_index == MOUSE_BUTTON_WHEEL_DOWN:
			target_zoom = clamp(target_zoom - zoom_speed, min_zoom, max_zoom)

	if event is InputEventScreenPinch:
		target_zoom = clamp(target_zoom * event.relative_scale, min_zoom, max_zoom)

	if event is InputEventScreenDrag:
		if event.index > 0: # Two finger drag to pan
			is_dragging = true
			global_position -= event.relative / zoom
		else:
			is_dragging = false
