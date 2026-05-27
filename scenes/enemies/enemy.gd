extends CharacterBody3D

@export var max_health : float = 20.0

@onready var health_component: HealthComponent = $HealthComponent
@onready var navigation_agent_3d: NavigationAgent3D = $NavigationAgent3D
@onready var proto_model: Node3D = $ProtoModel

@onready var player: Player = get_tree().get_first_node_in_group("Player")
func _ready() -> void:
	health_component.update_max_health(max_health)

func _physics_process(delta: float) -> void:
	var velocity_target := Vector3.ZERO
	navigation_agent_3d.target_position = player.global_position
	if not navigation_agent_3d.is_target_reached():
		velocity_target = get_local_navigation_direction() * 5.0
		orient_body(navigation_agent_3d.get_next_path_position())
		
	navigation_agent_3d.velocity = velocity_target

func orient_body(target_position: Vector3) -> void:
	target_position.y = proto_model.global_position.y
	if proto_model.global_position.is_equal_approx(target_position):
		return
	proto_model.look_at(target_position, Vector3.UP, true)

func get_local_navigation_direction() -> Vector3:
	var destination = navigation_agent_3d.get_next_path_position()
	var local_destination = destination - global_position
	return local_destination.normalized()


func _on_navigation_agent_3d_velocity_computed(safe_velocity: Vector3) -> void:
	velocity = safe_velocity
	move_and_slide()
