extends Zombie

@export var projectile : PackedScene

@onready var mouth_1: MeshInstance3D = $ProtoModel/Mouth1

func _on_timer_timeout() -> void:
	var shot = projectile.instantiate()
	add_child(shot)
	shot.global_position = mouth_1.global_position
	shot.direction = (player.global_position - mouth_1.global_position).normalized()
