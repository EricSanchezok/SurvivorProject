extends Player


func _ready() -> void:
<<<<<<< Updated upstream
	super()
	#register_weapon.emit(self, "normal_turret", 1)
=======
	#super()
	register_weapon.emit(self, "normal_bomb", 1)
>>>>>>> Stashed changes
	#register_weapon.emit(self, "normal_bomb", 2)
	#register_weapon.emit(self, "normal_boomerang", 3)
	#register_weapon.emit(self, "normal_axe", 4)
	#register_weapon.emit(self, "normal_axe", 5)
	#register_weapon.emit(self, "normal_axe", 6)
	#register_weapon.emit(self, "normal_axe", 7)
	#register_weapon.emit(self, "normal_axe", 8)
	#register_weapon.emit(self, "normal_axe", 9)
	#register_weapon.emit(self, "normal_axe", 10)
	pass
