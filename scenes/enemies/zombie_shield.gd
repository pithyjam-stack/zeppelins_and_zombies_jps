extends Area3D

class_name Zom_Armor

@export var max_strength := 20.0
@export var current_strength := 20.0

@onready var health_component: HealthComponent = $HealthComponent

func _ready() -> void:
	health_component.max_health = max_strength
	health_component.current_health = current_strength

func _physics_process(delta: float) -> void:
	if health_component.current_health <= 0:
		queue_free()
	

# Placeholder for when player shoots shield
func _on_area_entered(area: Area3D) -> void:
	if area is not Zom_Ball:
		health_component.take_damage(2)
		print("taking damage!")
	
