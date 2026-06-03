extends Zombie

@export var zom_shield : PackedScene

@onready var marker_3d: Marker3D = $ProtoModel/Marker3D

func _ready() -> void:
	super._ready()
	
	var shield_instance = zom_shield.instantiate()
	marker_3d.add_child(shield_instance)
	shield_instance.position = Vector3.ZERO
	shield_instance.rotation = Vector3.ZERO
