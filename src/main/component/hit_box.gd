extends Area2D

signal hit(hurtbox)

func _init() -> void:
	area_entered.connect(_on_area_entered)
	
func _on_area_entered(hurtbox: Area2D) -> void:
	# print("[Hit] %s => %s" % [owner.name, hurtbox.owner.name])
	hit.emit(hurtbox)
	hurtbox.hurt.emit(self)
