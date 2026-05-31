extends CharacterBody3D

class_name Player

@export var path : Path3D
@export var min_path_dist : float = 0.0
@export var max_path_dist : float = 100.0
@export var side_limit : float = 2.0
@export var horizontal_speed := 5.0
@export var lateral_speed := 2.0
@export var rotation_smoothness := 10.0

const JUMP_VELOCITY = 4.5


var path_distance: float = 0.0
var side_offset : float = 0.0

@onready var curve = path.curve
@onready var center_pivot: Node3D = $CenterPivot
@onready var hand_position: Node3D = $CenterPivot/HandPosition


func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
	
	# Handle jump.
	if Input.is_action_just_pressed("move_jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY
	
	var input_horizontal = Input.get_axis("move_right", "move_left")
	var input_lateral = Input.get_axis("move_backward", "move_forward")
	
	path_distance += input_horizontal * horizontal_speed * delta
	side_offset += input_lateral * lateral_speed * delta
	
	path_distance = clampf(path_distance, min_path_dist, max_path_dist)
	side_offset = clampf(side_offset, -side_limit, side_limit)
	
	var center_curve := curve.sample_baked(path_distance, true)
	var ahead_curve := curve.sample_baked(path_distance + 0.2, true)
	
	var tangent := (ahead_curve - center_curve).normalized()
	var right := tangent.cross(Vector3.UP).normalized()
	
	var target_position := path.global_transform * (center_curve + right * side_offset)
	global_position = target_position
	
	var _move_direction = tangent * sign(input_horizontal) + right * sign(input_lateral)
	#if move_direction.length() > 0.01:
		#_rotate_to_direction(_move_direction.normalized(), delta)
	_rotate_camera_to_path_direction(tangent, delta)


func _rotate_camera_to_path_direction(local_tangent: Vector3, delta: float) -> void:
	var world_direction := path.global_transform.basis * local_tangent
	world_direction.y = 0.0
	if world_direction.length() < 0.001:
		return
	
	world_direction = world_direction.normalized()
	
	var target_basis := Basis.looking_at(world_direction, Vector3.UP)
	
	var turn_weight := clampf(rotation_smoothness * delta, 0.0, 1.0)
	$CameraHandle.global_basis = $CameraHandle.global_basis.slerp(target_basis, turn_weight)

func _aim_weapon_at_position(direction: Vector3, delta: float) -> void:
	hand_position.global_basis = Basis.looking_at(direction, Vector3.UP)

func _rotate_to_direction(local_direction: Vector3, delta: float) -> void:
	var world_direction := path.global_transform.basis * local_direction
	world_direction.y = 0.0
	world_direction = world_direction.normalized()
	
	if world_direction.length() < 0.001:
		return
	
	var target_basis := Basis.looking_at(world_direction, Vector3.UP)
	var turn_weight := clampf(rotation_smoothness * delta, 0.0, 1.0)
	$MeshInstance3D.global_basis = $MeshInstance3D.global_basis.slerp(target_basis, turn_weight)
	center_pivot.global_basis = center_pivot.global_basis.slerp(target_basis, turn_weight)
