class_name WeaponInstance
extends Node

@onready var weapons = {
	"surtr's_fury": preload("res://src/main/scene/role/weapons/Sword/Surtr's Fury/surtr's_fury.tscn"),
}


func instance_weapon(weapon_name: String) -> Node:
	return weapons[weapon_name].instantiate()
