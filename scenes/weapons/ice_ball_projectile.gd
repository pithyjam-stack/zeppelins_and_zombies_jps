extends Projectile

@export var slow_ratio := 0.95
@export var duration := 1.5


func _on_body_entered(body: Node3D) -> void:
	if body is Zombie:
		var manager = StatusEffectManager.attach_or_retrieve(body)
		var status_slow = get_node_or_null("StatusEffectSlow")
		if status_slow:
			# 4.0 so it doesn't just stack a whole lot : could refactor
			status_slow.increase_slow(slow_ratio, duration / 4.0)
		else:
			manager.add_child(Status_Effect_Slow.new(slow_ratio, duration))
	super._on_body_entered(body)
