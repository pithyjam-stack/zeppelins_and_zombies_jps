extends Status_Effect
class_name Status_Effect_Slow

var slow_ratio := 0.5
var duration := 1.0
var zombie_original_speed
var timer : Timer

@onready var zombie := get_parent().get_parent() as Zombie

func _init(_slow_ratio: float, _duration : float):
	slow_ratio = _slow_ratio
	duration = _duration

func _ready() -> void:
	zombie_original_speed = zombie.speed
	zombie.speed *= slow_ratio
	
	timer = Timer.new()
	timer.autostart = true
	timer.one_shot = true
	add_child(timer)
	timer.start(duration)
	timer.timeout.connect(_on_timer_timeout)
	
	pass

func _on_timer_timeout():
	zombie.speed = zombie_original_speed
	queue_free()

func increase_slow(ratio, duration):
	zombie.speed *= ratio
	timer.start(timer.time_left + duration)
