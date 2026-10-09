extends Node3D

@onready var repair_timer: Timer = $RepairTimer
@onready var steam_parts: Node3D = $SteamParts
@onready var balloons: Node3D = $Balloons
@onready var secondary_parts: Node3D = $SecondaryParts
@onready var valves: Node3D = $Valves
@onready var fans: Node3D = $Fans

var time_held : float = 0.0
var hold_time := 0.0
var time_passed := 0.0

func _ready() -> void:
	time_held = 0.0

func _on_repaired(player : Node3D, delta : float) -> void:
	hold_time += delta
	time_passed += delta
	if time_passed >= 1.0:
		print("Holding... Current time: ", hold_time)
		time_passed -= 1.0
	if Input.is_action_just_released("repair"):
		time_held += hold_time
		print("Total Time Held: ", time_held, " seconds.")
		repair_timer.start()
		print("Starting repair timer!")
		
		hold_time = 0.0

func _on_timer_timeout() -> void:
	print("Zeppelin being repaired!")
	if time_held > 10.0:
		steam_parts.visible = true
	if time_held > 15.0:
		balloons.visible = true
	if time_held > 20.0:
		secondary_parts.visible = true
	if time_held > 25.0:
		valves.visible = true
	if time_held > 30.0:
		fans.visible = true
