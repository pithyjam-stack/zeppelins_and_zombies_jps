extends Node3D

@export var scale_factor := Vector3(1.0, 1.0, 1.0)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func on_interacted(player: Node3D) -> void:
	var model := player.get_node("MeshInstance3D")
	model.get_node("MeshInstance3D").scale = scale_factor
	model.get_node("MeshInstance3D2").scale = scale_factor
