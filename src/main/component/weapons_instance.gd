extends Node



@onready var weapons = {
	"normal_sword": preload("res://src/main/scene/role/weapons/Sword/normal_sword.tscn"),
	"normal_shield": preload("res://src/main/scene/role/weapons/Shield/normal_shield.tscn"),
	"normal_dagger": preload("res://src/main/scene/role/weapons/Dagger/normal_dagger.tscn"),
	"normal_bow": preload("res://src/main/scene/role/weapons/Bow/normal_bow.tscn"),
	"normal_axe": preload("res://src/main/scene/role/weapons/Axe/normal_axe.tscn"),
	"normal_spear": preload("res://src/main/scene/role/weapons/Spear/normal_spear.tscn"),
	"normal_boomerang": preload("res://src/main/scene/role/weapons/Boomerang/normal_boomerang.tscn"),
	"normal_wand": preload("res://src/main/scene/role/weapons/Wand/normal_wand.tscn"),
	"normal_gun": preload("res://src/main/scene/role/weapons/Gun/normal_gun.tscn"),
	"normal_bomb": preload("res://src/main/scene/role/weapons/Bomb/normal_bomb.tscn"),
	"normal_turret": preload("res://src/main/scene/role/weapons/Turret/normal_turret.tscn"),
	"normal_laser_wand": preload("res://src/main/scene/role/weapons/LaserWand/normal_laser_wand.tscn"),
}


func instance_weapon(weapon_name: String) -> Node:
	return weapons[weapon_name].instantiate()
