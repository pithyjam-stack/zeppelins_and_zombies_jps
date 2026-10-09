extends Node3D

@export var scale_factor := Vector3(1.0, 1.0, 1.0)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func on_interacted(player: Node3D) -> void:
	# v v v Code below is potentially deprecated v v v
	"""
	var model := player.get_node("MeshInstance3D")
	model.get_node("MeshInstance3D").scale += scale_factor * 0.5
	model.get_node("MeshInstance3D2").scale += scale_factor * 0.5
	"""
	
	# v v v Health Station Implementation v v v 
	var health : HealthComponent = player.health_component
	if health.current_health < health.max_health - 4:
		health.current_health += 5 
	else:
		health.current_health += (health.max_health - health.current_health)
	
