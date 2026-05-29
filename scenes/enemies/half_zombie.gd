extends Zombie

@export var ball_scene : PackedScene

@onready var half_zombie: CharacterBody3D = $"."

var attacking := false

func _ready() -> void:
	attack_loop()

func attack_loop() -> void:
	if attacking:
		return
	
	attacking = true
	
	while max_health > 0:
		throw_projectile()
		await get_tree().create_timer(1.5).timeout
	
	attacking = false

func throw_projectile() -> void:
	var projectile := ball_scene.instantiate() as Node3D
	get_tree().current_scene.add_child(projectile)
	
	var start_pos := global_position
	var target_pos := player.global_position
	
	projectile_throw(projectile, start_pos, target_pos)

func projectile_throw(projectile: Node3D, start_pos: Vector3, target_pos: Vector3) -> void:
	var duration := 0.8
	var arc_height := 3.0
	
	projectile.global_position = start_pos
	
	var tween := create_tween()
	
	tween.tween_method(
		func(t: float):
			var flat_pos := start_pos.lerp(target_pos, t)
			
			# Parabola: 0 at start/end, 1 at middle
			var height := sin(t * PI) * arc_height
			
			projectile.global_position = flat_pos + Vector3.UP * height,
			0.0,
			1.0,
			duration
	)
	
	tween.tween_callback(projectile.queue_free)
