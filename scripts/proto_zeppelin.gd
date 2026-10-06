extends Node3D

@onready var repair_timer: Timer = $RepairTimer
@onready var steam_parts: Node3D = $SteamParts
@onready var balloons: Node3D = $Balloons
@onready var secondary_parts: Node3D = $SecondaryParts
@onready var valves: Node3D = $Valves
@onready var fans: Node3D = $Fans

var time_held : float = 0.0

func _ready() -> void:
	time_held = 0.0

func _on_iteractable_repairing(hold_time : float) -> void:
	time_held += hold_time
	print("Total Time Held: ", time_held, " seconds.")
	repair_timer.start()
	print("Starting repair timer!")


func _on_timer_timeout() -> void:
	print("Zeppelin being repaired!")
	if time_held > 30.0:
		steam_parts.visible = true
	if time_held > 35.0:
		balloons.visible = true
	if time_held > 40.0:
		secondary_parts.visible = true
	if time_held > 45.0:
		valves.visible = true
	if time_held > 50.0:
		fans.visible = true
