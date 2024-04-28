extends WeaponBase

@onready var hit_box: HitBox = $Graphics/HitBox



func _on_hit_box_timer_timeout() -> void:
	hit_box.monitoring = false if hit_box.monitoring else true
