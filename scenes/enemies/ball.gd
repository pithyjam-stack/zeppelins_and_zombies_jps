extends Area3D

class_name Zom_Ball

var direction := Vector3.FORWARD

@export var speed := 30.0

func _physics_process(delta: float) -> void:
	global_position += direction * speed * delta

func _on_timer_timeout() -> void:
	queue_free()
