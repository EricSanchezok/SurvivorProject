extends Node2D


@onready var weapons_instance: WeaponsInstance = $WeaponsInstance

var players = []

func _ready() -> void:
	players = get_tree().get_nodes_in_group("player")


func register_weapon(weapon_slot: int, weapon) -> void:
	'''
	注册武器到指定的槽位
	
	:param weapon_slot: 武器槽位
	:param weapon: 武器节点
	'''
	var weapon_slot_instance = _get_weapon_slot_instance(weapon_slot)
	weapon_slot_instance.add_child(weapon)
	
func unregister_weapon(weapon_slot: int) -> void:
	'''
	从指定的槽位注销武器

	:param weapon_slot: 武器槽位
	'''
	var weapon_slot_instance = _get_weapon_slot_instance(weapon_slot)
	var weapon = weapon_slot_instance.get_child(0)
	weapon_slot_instance.remove_child(weapon)