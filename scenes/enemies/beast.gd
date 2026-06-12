extends Zombie

@export var zom_armor : PackedScene

@onready var marker_3d: Marker3D = $ProtoModel/Marker3D

func orient_body(target_position: Vector3) -> void:
	super.orient_body(target_position)
	
	collision_shape_3d.rotation.z = -proto_model.rotation.y

func _ready() -> void:
	super._ready()
	
	var shield_instance = zom_armor.instantiate()
	marker_3d.add_child(shield_instance)
	shield_instance.position = Vector3.ZERO
	shield_instance.rotation = Vector3.ZERO
