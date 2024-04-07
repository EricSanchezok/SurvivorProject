extends Player




func _ready() -> void:
	weapons_track.register_weapon(1, weapons_instance.normal_sword.instantiate())
	weapons_track.register_weapon(2, weapons_instance.normal_sword.instantiate())
	weapons_track.register_weapon(3, weapons_instance.normal_sword.instantiate())
	weapons_track.register_weapon(4, weapons_instance.normal_sword.instantiate())
	weapons_track.register_weapon(5, weapons_instance.normal_sword.instantiate())
	weapons_track.register_weapon(6, weapons_instance.normal_sword.instantiate())
	weapons_track.register_weapon(7, weapons_instance.normal_sword.instantiate())
	weapons_track.register_weapon(8, weapons_instance.normal_sword.instantiate())
	weapons_track.register_weapon(9, weapons_instance.normal_sword.instantiate())
