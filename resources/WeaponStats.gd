extends Resource
class_name WeaponStats

enum FiringMode {SEMI, AUTO}

@export var weapon_name: String
@export var weapon_firing_mode: FiringMode
@export var damage :int = 1
@export var magazine_capacity: int = 1
@export var reload_time: float = 1.5
@export var fire_frequency: float = 0.3
@export var projectile_scene: PackedScene
@export var projectile_count: int = 1
@export var spread: float = 0.0
