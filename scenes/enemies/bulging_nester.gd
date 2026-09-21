extends Zombie

#@export var mutant_hatchling : PackedScene
@export var burrower : PackedScene

@onready var marker_3d: Marker3D = $ProtoModel/Spawners/Marker3D
@onready var marker_3d_2: Marker3D = $ProtoModel/Spawners/Marker3D2
@onready var marker_3d_3: Marker3D = $ProtoModel/Spawners/Marker3D3

func _ready() -> void:
	super._ready()
	
	#var hatchling_instance = mutant_hatchling.instantiate()
	
func _on_timer_timeout() -> void:
	print("Spawning burrowers...")
	var burrower_instance = burrower.instantiate()
	var burrower_instance_2 = burrower.instantiate()
	var burrower_instance_3 = burrower.instantiate()
	get_tree().current_scene.add_child(burrower_instance)
	get_tree().current_scene.add_child(burrower_instance_2)
	get_tree().current_scene.add_child(burrower_instance_3)
	burrower_instance.global_position = marker_3d.global_position
	burrower_instance_2.global_position = marker_3d_2.global_position
	burrower_instance_3.global_position = marker_3d_3.global_position
