extends Weapon

@export var warm_up_time := 1.0
@export var spread_rate := 4.0
@export var spread_amount_max := 15.0

var warm_up_timer : Timer
var is_warm := false
var is_shooting := false
var spread_amount : float


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	super._ready()
	warm_up_timer = Timer.new()
	add_child(warm_up_timer)
	warm_up_timer.one_shot = true
	warm_up_timer.connect("timeout", _on_warm_up_timer_timeout)

func _process(delta: float) -> void:
	super._process(delta)
	if Input.is_action_just_released("shoot"):
		is_warm = false
		warm_up_timer.stop()
		is_shooting = false
	
	if is_shooting:
		spread_amount += spread_rate * delta
	else:
		spread_amount -= spread_rate * delta
	spread_amount = clampf(spread_amount, 0, spread_amount_max)
	stats.spread = spread_amount

func try_shoot() -> void:
	if not can_fire:
		return
	if is_reloading:
		return
	
	if !is_warm:
		if warm_up_timer.time_left == 0:
			warm_up_timer.start(warm_up_time)
		return
	
	shoot()
	current_ammo -= 1
	
	if current_ammo <= 0:
		reload()
	
	_hold_fire_between_shots()

func shoot():
	super.shoot()
	is_shooting = true

func _on_warm_up_timer_timeout():
	print("time")
	is_warm = true
