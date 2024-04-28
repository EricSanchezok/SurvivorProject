class_name Damage
extends RefCounted

var source: Node2D
var direction: Vector2

var is_critical: bool = false

var phy_amount: float
var mag_amount: float
var knockback: float

# 为敌人攻击玩家特有的 amount，通常玩家的武器攻击敌人不会用到这个值
var amount: float



