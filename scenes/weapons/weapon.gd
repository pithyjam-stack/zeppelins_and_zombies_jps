extends Node3D
class_name Weapon

@export var stats: WeaponStats
@onready var muzzle: Node3D = $Muzzle
@onready var fire_rate_timer: Timer = $Fire_Rate_Timer
@onready var reloading_timer: Timer = $Reloading_Timer


var current_ammo : int
var can_fire := true
var is_reloading := false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	current_ammo = stats.magazine_capacity
	fire_rate_timer.wait_time = stats.fire_frequency
	reloading_timer.wait_time = stats.reload_time


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("shoot") and stats.weapon_firing_mode ==  stats.FiringMode.SEMI:
		try_shoot()
	elif Input.is_action_pressed("shoot") and stats.weapon_firing_mode == stats.FiringMode.AUTO:
		try_shoot()

func _unhandled_input(event: InputEvent) -> void:
	pass

func try_shoot() -> void:
	if not can_fire:
		return
	if is_reloading:
		return
	
	shoot()
	current_ammo -= 1
	if current_ammo <= 0:
		reload()
	
	_hold_fire_between_shots()

func _hold_fire_between_shots() -> void:
	can_fire = false
	fire_rate_timer.start()
	await fire_rate_timer.timeout
	can_fire = true

func shoot() -> void:
	print("Shot my gun. ", current_ammo, " ammo remaining.")
	for i in stats.projectile_count:
		var projectile := stats.projectile_scene.instantiate()
		get_tree().get_root().add_child(projectile)
		
		projectile.global_position = muzzle.global_position
		projectile.global_rotation = global_rotation
		
		var spread_horizontal := deg_to_rad(randf_range(-stats.spread, stats.spread))
		var spread_vertical := deg_to_rad(randf_range(-stats.spread, stats.spread))
		projectile.rotate_y(spread_horizontal)
		projectile.rotate_x(spread_vertical)
		var firing_direction = -muzzle.global_transform.basis.z  + Vector3(-spread_horizontal,spread_vertical,0)
		firing_direction = firing_direction.normalized()
		projectile.set_values(firing_direction, stats.damage)

func reload() -> void:
	print("Reloading...")
	is_reloading = true
	reloading_timer.start()
	await reloading_timer.timeout
	print("Reloaded ", stats.magazine_capacity, " Ammo")
	is_reloading = false
	current_ammo = stats.magazine_capacity
