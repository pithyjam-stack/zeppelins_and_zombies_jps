extends Node3D

@export var weapon: PackedScene

@onready var gun_station_menu: Control = $GunStationMenu

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func on_interacted(player: Node3D) -> void:
	#print("Giving Weapon")
	#player.add_weapon(weapon)
	gun_station_menu.visible = !gun_station_menu.visible
	if gun_station_menu.visible:
		get_tree().paused = true
	else:
		get_tree().paused = false
