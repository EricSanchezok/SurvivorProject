class_name WeaponsInstance
extends Node



@onready var weapons = {
	"normal_sword": preload("res://src/main/scene/role/weapons/normal_sword.tscn"),
	"normal_shield": preload("res://src/main/scene/role/weapons/normal_shield.tscn"),
}


func instance_weapon(weapon_name: String) -> Node:
	return weapons[weapon_name].instantiate()
