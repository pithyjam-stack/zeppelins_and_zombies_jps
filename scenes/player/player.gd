extends CharacterBody3D


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
	
	_rotate_to_path_direction(tangent, delta)
	#move_and_slide()


func _rotate_to_path_direction(local_tangent: Vector3, delta: float) -> void:
	var world_tangent := path.global_transform.basis * local_tangent
	world_tangent.y = 0.0
	world_tangent = world_tangent.normalized()
	
	if world_tangent.length() < 0.001:
		return
	
	var target_basis := Basis.looking_at(world_tangent, Vector3.UP)
	global_basis = global_basis.slerp(target_basis, rotation_smoothness * delta)
