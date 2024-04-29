class_name WeaponInstance
extends Node

@onready var weapons = {
	"surtr's_fury": preload("res://src/main/scene/role/weapons/Sword/Surtr's Fury/surtr's_fury.tscn"),
	"doom_bringer": preload("res://src/main/scene/role/weapons/Gun/Doombringer/doom_bringer.tscn"),
	"frost_shield": preload("res://src/main/scene/role/weapons/Shield/Frost Shield/frost_shield.tscn"),
	"frostbite_touch": preload("res://src/main/scene/role/weapons/Staff/Frostbite Touch/frostbite_touch.tscn"),
	"fire_guardian": preload("res://src/main/scene/role/weapons/Turret/Fire Guardian/fire_guardian.tscn"),
	"snowfield_blade": preload("res://src/main/scene/role/weapons/Dagger/Snowfield Blade/snowfield_blade.tscn"),
}


func instance_weapon(weapon_name: String) -> Node:
	return weapons[weapon_name].instantiate()
