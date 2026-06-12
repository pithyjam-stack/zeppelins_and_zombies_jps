extends Zombie

@onready var sub_model: Node3D = $ProtoModel/SubModel
@onready var area_attack: ShapeCast3D = $ProtoModel/AreaAttack

func _burrow() -> void:
	var tween = create_tween()
	
	tween.tween_property(sub_model, "position", Vector3(0, -0.4, 0), 0.5)
	
func _unburrow() -> void:
	var tween = create_tween()
	
	tween.tween_property(sub_model, "position", Vector3(0, 0, 0), 0.1)
	
func check_for_attacks() -> void:
	for collision_id in player_detector.get_collision_count():
		var collider = player_detector.get_collider(collision_id)
		if collider is Player:
			_unburrow()
	_burrow()

func _physics_process(delta: float) -> void:
	super._physics_process(delta)
	

func orient_body(target_position: Vector3) -> void:
	super.orient_body(target_position)
	
	collision_shape_3d.rotation.z = -proto_model.rotation.y
