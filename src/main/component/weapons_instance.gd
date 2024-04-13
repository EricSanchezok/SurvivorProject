extends Node



@onready var weapons = {
	"normal_sword": preload("res://src/main/scene/role/weapons/Sword/normal_sword.tscn"),
	"normal_shield": preload("res://src/main/scene/role/weapons/Shield/normal_shield.tscn"),
	"normal_dagger": preload("res://src/main/scene/role/weapons/Dagger/normal_dagger.tscn"),
	"normal_bow": preload("res://src/main/scene/role/weapons/Bow/normal_bow.tscn"),
}


func instance_weapon(weapon_name: String) -> Node:
	return weapons[weapon_name].instantiate()
