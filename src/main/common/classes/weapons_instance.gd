class_name WeaponInstance
extends Node

@onready var weapons = {
	"surtr's_fury": preload("res://src/main/scene/role/weapons/Sword/Surtr's Fury/surtr's_fury.tscn"),
	"skyblast_cannon": preload("res://src/main/scene/role/weapons/Gun/SkyBlast Cannon/skyblast_cannon.tscn"),
	"frost_shield": preload("res://src/main/scene/role/weapons/Shield/Frost Shield/frost_shield.tscn"),
	"frostbite_touch": preload("res://src/main/scene/role/weapons/Staff/Frostbite Touch/frostbite_touch.tscn"),
	"fire_guardian": preload("res://src/main/scene/role/weapons/Turret/Fire Guardian/fire_guardian.tscn"),
	"storm_axe": preload("res://src/main/scene/role/weapons/Axe/Storm Axe/storm_axe.tscn"),
}


func instance_weapon(weapon_name: String) -> Node:
	return weapons[weapon_name].instantiate()
