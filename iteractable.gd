extends Node3D

@export var message := "Use Desc"
@export var collision_radius := 2.0

var nearby_player : Node3D = null

@onready var detection_area: Area3D = $DetectionArea

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_setup_collision_shape()
	
	detection_area.connect("body_entered", _on_body_entered)
	detection_area.connect("body_exited", _on_body_exited)

func _process(delta: float) -> void:
	if nearby_player and Input.is_action_just_pressed("interact"):
		try_interact(nearby_player)

func try_interact(player: Node3D) -> void:
	if not can_interact():
		return
	
	var station := get_parent()
	print("Player interacted with ", station.name)
	if station.has_method("on_interacted"):
		station.on_interacted(nearby_player)

func can_interact() -> bool:
	return true

func _setup_collision_shape() -> void:
	var collision_shape := detection_area.get_node_or_null("CollisionShape3D")
	if collision_shape is CollisionShape3D:
		var sphere_shape = SphereShape3D.new()
		sphere_shape.radius = collision_radius
		collision_shape.shape = sphere_shape

func _on_body_entered(body: Node3D) -> void:
	if body.is_in_group("Player"):
		nearby_player = body

func _on_body_exited(body: Node3D) -> void:
	if body.is_in_group("Player"):
		nearby_player = null
