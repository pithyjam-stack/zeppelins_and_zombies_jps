extends Camera3D

@onready var ray_cast_3d: RayCast3D = $RayCast3D

const RAY_DISTANTCE = 100

var shape : MeshInstance3D
var player : Player

func _ready() -> void:
	#shape = MeshInstance3D.new()
	#shape.mesh = SphereMesh.new()
	#shape.name = "DEBUG VISUAL AIM"
	#get_tree().root.add_child.call_deferred(shape)
	player = get_tree().get_first_node_in_group("Player")

func _process(delta: float) -> void:
	var mouse_position : Vector2 = get_viewport().get_mouse_position()
	ray_cast_3d.target_position = project_local_ray_normal(mouse_position) * RAY_DISTANTCE
	ray_cast_3d.force_raycast_update()
	
	var collider := ray_cast_3d.get_collider()
	if ray_cast_3d.is_colliding():
		if collider.is_in_group("Player"):
			return
			
		elif collider.is_in_group("Floor"):
			var direction : Vector3 = ray_cast_3d.get_collision_point() - player.hand_position.global_position
			player._rotate_to_direction(direction, delta)
			player._aim_weapon_at_position(direction, delta)
		
		elif collider is Zombie or Zom_Armor:
			var direction : Vector3 = collider.global_position - player.hand_position.global_position
			player._rotate_to_direction(direction, delta)
			player._aim_weapon_at_position(direction, delta)
