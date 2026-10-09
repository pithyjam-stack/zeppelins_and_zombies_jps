extends CharacterBody3D

class_name Zombie

signal attackable

@export var max_health : float = 20.0
@export var damage : int = 10
@export var speed : float = 5.0
@export var time_to_attack : float = 2.0

@onready var health_component: HealthComponent = $HealthComponent
@onready var navigation_agent_3d: NavigationAgent3D = $NavigationAgent3D
@onready var proto_model: Node3D = $ProtoModel
@onready var player_detector: ShapeCast3D = $ProtoModel/PlayerDetector
@onready var collision_shape_3d: CollisionShape3D = $CollisionShape3D
@onready var animation_player: AnimationPlayer = $"ProtoModel/z&z_proto_zombie/AnimationPlayer"
@onready var area_attack: ShapeCast3D = $ProtoModel/AreaAttack
@onready var attack_timer: Timer = $AttackTimer

@onready var player: Player = get_tree().get_first_node_in_group("Player")

func _ready() -> void:
	health_component.update_max_health(max_health)
	attack_timer.set_wait_time(time_to_attack)
	#print(attack_timer.wait_time)

func check_for_attacks() -> void:
	for collision_id in player_detector.get_collision_count():
		var collider = player_detector.get_collider(collision_id)
	
func _physics_process(delta: float) -> void:
	check_for_attacks()
	
	
	var velocity_target := Vector3.ZERO
	navigation_agent_3d.target_position = player.global_position
	if not navigation_agent_3d.is_target_reached():
		velocity_target = get_local_navigation_direction() * speed
		orient_body(navigation_agent_3d.get_next_path_position())
		#animation_player.play("Walk")
		
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

func _on_health_component_defeat() -> void:
	queue_free()

func _on_attack_timer_timeout() -> void:
	area_attack.deal_damage(damage)
