extends Weapon

@export var warm_up_rate := 1.0
@export var warm_up_to_shoot := 1.5
@export var spread_rate := 4.0
@export var spread_down_rate := 8.0
@export var spread_amount_max := 15.0

var warm_up_amount : float
var warm_up_max := 3.0
var is_warming := false

var spread_amount : float
var barrel_spin_rad_rate : float = 0.0
var is_shooting := false

@onready var barrels: Node3D = $Model/Barrels


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	super._ready()

func _process(delta: float) -> void:
	super._process(delta)
	if Input.is_action_just_released("shoot"):
		is_shooting = false
		is_warming = false
	
	
	if is_warming:
		warm_up_amount += warm_up_rate * delta
	else:
		warm_up_amount -= warm_up_rate * delta
	warm_up_amount = clampf(warm_up_amount, 0, warm_up_max)
	
	if is_shooting:
		spread_amount += spread_rate * delta
	else:
		spread_amount -= spread_down_rate * delta
	barrel_spin_rad_rate = lerpf(barrel_spin_rad_rate, warm_up_amount / warm_up_max + spread_amount / spread_amount_max, 0.05)
	spread_amount = clampf(spread_amount, 0, spread_amount_max)
	stats.spread = spread_amount
	
	if barrel_spin_rad_rate > 0.01:
		barrels.rotate_z(barrel_spin_rad_rate)

func try_shoot() -> void:
	if not can_fire:
		return
	if is_reloading:
		return
		
	is_warming = true
	if warm_up_amount < warm_up_to_shoot:
		return
	
	shoot()
	current_ammo -= 1
	
	if current_ammo <= 0:
		reload()
	
	_hold_fire_between_shots()

func shoot():
	super.shoot()
	is_shooting = true
