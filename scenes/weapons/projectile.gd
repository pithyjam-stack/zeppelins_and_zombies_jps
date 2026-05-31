extends Area3D

@export var speed := 10.0
@export var damage := 3.0
@export var lifetime := 3.0

@onready var life_timer: Timer = $Life_Timer
var direction = Vector3.FORWARD


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	life_timer.start(lifetime)


func _physics_process(delta: float) -> void:
	global_position += direction * speed * delta

func set_values(aim_direction: Vector3, weapon_damage: int) ->void:
	direction = aim_direction
	damage = weapon_damage

func _on_life_timer_timeout() -> void:
	queue_free()


func _on_body_entered(body: Node3D) -> void:
	if body is Zombie:
		var health_com = body.get_node_or_null("HealthComponent")
		if health_com:
			health_com.take_damage(damage)
