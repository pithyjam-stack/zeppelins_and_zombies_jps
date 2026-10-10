extends Node3D

var curr_weapon_index := 0
var curr_weapon : Weapon
var enemy_detected : bool = false

@export var stored_weapons : Array[Weapon]
@onready var gun_spawner: Marker3D = $GunSpawner
@onready var detection_radius: Area3D = $DetectionRadius

func _ready() -> void:
	curr_weapon = stored_weapons[curr_weapon_index]
	curr_weapon.can_fire = false
	stored_weapons[1].set_active(false)
	stored_weapons[2].set_active(false)
	
	print("Auto Turret Given Gun.")

func _physics_process(delta: float) -> void:
	var bodies : Array[Node3D] = detection_radius.get_overlapping_bodies()
	for body in bodies:
		if body.is_in_group("Enemy"):
			gun_spawner.look_at(body.global_position, Vector3.UP, true)
			curr_weapon.try_shoot()
	curr_weapon.can_fire = false


func on_interacted(player : Node3D) -> void:
	print("Cycling Auto Turret Weapon...")
	curr_weapon.set_active(false)
	curr_weapon_index = wrapi(curr_weapon_index + 1, 0, 3)
	curr_weapon = stored_weapons[curr_weapon_index]
	print(curr_weapon_index, " : ", curr_weapon.stats.weapon_name)
	curr_weapon.set_active(true)
	


func _on_detection_radius_body_entered(body: Node3D) -> void:
	if body.is_in_group("Enemy"):
		print("Enemy Detected.")
		enemy_detected = true
		curr_weapon.can_fire = true


func _on_detection_radius_body_exited(body: Node3D) -> void:
	gun_spawner.global_rotation = Vector3(0, 0, 0)
