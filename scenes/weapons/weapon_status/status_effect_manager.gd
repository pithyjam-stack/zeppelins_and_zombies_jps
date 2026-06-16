extends Node
class_name StatusEffectManager

var status_count : int = 0

static func attach_or_retrieve(body: Node3D):
	var manager = body.get_node_or_null("StatusEffectManager")
	if manager:
		return manager
	else:
		manager = StatusEffectManager.new()
		body.add_child(manager)
		return manager
