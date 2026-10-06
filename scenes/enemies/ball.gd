extends RigidBody3D

var direction := Vector3.FORWARD
var velocity := Vector3(0, 0, 0)

@export var speed := 30.0

func _on_timer_timeout() -> void:
	queue_free()

func _on_body_entered(body: Node3D) -> void:
	if body is Player:
		body.health_component.take_damage(20)
		print("Dealt damage to Player!")
		queue_free()
	else:
		call_deferred("queue_free")
