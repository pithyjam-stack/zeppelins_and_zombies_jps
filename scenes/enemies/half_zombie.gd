extends Zombie

@export var projectile : PackedScene
@export var projectile_speed := 30.0

@onready var marker_3d: Marker3D = $ProtoModel/Marker3D

func _on_attack_timer_timeout() -> void:
	var shot = projectile.instantiate()
	#print("Preparing to Fire!")
	marker_3d.add_child(shot)
	shot.global_position = marker_3d.global_position
	
	var dir: Vector3 = marker_3d.global_transform.basis.z
	shot.linear_velocity = dir * projectile_speed
