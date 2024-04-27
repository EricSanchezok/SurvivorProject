extends Node2D

# >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> 武器基类 >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
var slot: Node2D
var player: CharacterBody2D
var playerStats: Node

# >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> 节点引用 >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
@onready var searching_shape_2d: CollisionShape2D = $Area2D/CollisionShape2D
@onready var attack_wait_timer: Timer = $AttackWaitTimer
@onready var hit_box: HitBox = $Graphics/HitBox
@onready var animation_player: AnimationPlayer = $AnimationPlayer

# >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> 基础属性 >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
@export var base_power_physical: float = 4.0  #物理攻击力
@export var base_power_magic: float = 2.0   #魔法攻击力
@export var base_time_cooldown: float = 1  #攻击冷却
@export var base_speed_rotation: float = 15.0   #旋转速度
@export var base_range_attack: float = 150.0 #攻击范围
@export var base_range_explosion: = 50   #爆炸范围
@export var base_knockback: float = 30.0    #击退效果
@export var base_critical_hit_rate: float = 0.0  #暴击率
@export var base_critical_damage: float = 0.0    #暴击伤害
@export var base_number_of_projectiles: int = 1   #发射物数量
@export var base_speed_fly: float = 200.0   #武器飞行速度
@export var base_penetration_rate: = 0  #穿透率
@export var base_magazine: = 0  #弹匣

# >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> 当前属性 >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
var power_physical: float = base_power_physical #物理攻击力
var power_magic: float = base_power_magic #魔法攻击力
var damage: float = power_physical + power_magic #总攻击力
var time_cooldown: float = base_time_cooldown   #攻击冷却
var speed_rotation: float = base_speed_rotation  #旋转速度
var range_attack: float = base_range_attack  #攻击范围
var range_explosion: float = base_range_explosion  #爆炸范围
var knockback: float = base_knockback  #击退效果
var critical_hit_rate: float = base_critical_hit_rate #暴击率
var critical_damage: float = base_critical_damage #暴击伤害
var number_of_projectiles: int = base_number_of_projectiles #发射物数量
var speed_fly: float = base_speed_fly  #武器飞行速度
var penetration_rate: float = base_penetration_rate  #穿透率
var magazine: float  = base_magazine  #弹匣


# >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> 变量定义 >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
var enemies: Array = []
var target: CharacterBody2D = null

var isBezier: bool = true

func _ready() -> void:
	'''
	初始化

	:return: void
	'''

# >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> 属性更新 >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
func modify_attribute(attribute_name: String, change_type: String, value : float):
	# 使用match语句选择属性和修改类型
	match attribute_name:
# >>>>>>>>>>>>>>>>>>>>> 物理伤害相关 >>>>>>>>>>>>>>>>>>>>>>>>
		"power_physical":
			match change_type:
				"percent":
					power_physical += base_power_physical * value  
					damage =  power_physical + power_magic
				"absolute":
					power_physical += value
					damage =  power_physical + power_magic
# >>>>>>>>>>>>>>>>>>>>> 魔法伤害相关 >>>>>>>>>>>>>>>>>>>>>>>>
		"power_magic":
			match change_type:
				"percent":
					power_magic += base_power_magic * value
					damage =  power_physical + power_magic
				"absolute":
					power_magic += value
					damage =  power_physical + power_magic
# >>>>>>>>>>>>>>>>>>>>> 攻击冷却相关 >>>>>>>>>>>>>>>>>>>>>>>>
		"time_cooldown":
			match change_type:
				"percent":
					if value == 0:
						return
					time_cooldown += base_time_cooldown / value
					speed_rotation += base_speed_rotation * value
				"absolute":
					time_cooldown += value
# >>>>>>>>>>>>>>>>>>>>> 攻击范围相关 >>>>>>>>>>>>>>>>>>>>>>>>
		"base_range_attack":
			match change_type:
				"percent":
					range_attack += base_range_attack * value
					searching_shape_2d.shape.radius = range_attack
					range_explosion += base_range_explosion * value
				"absolute":
					range_attack += value
					searching_shape_2d.shape.radius = range_attack
					range_explosion += value
# >>>>>>>>>>>>>>>>>>>>> 击退相关 >>>>>>>>>>>>>>>>>>>>>>>>
		"knockback":
			match change_type:
				"percent":
					knockback += base_knockback * value
				"absolute":
					knockback += value
# >>>>>>>>>>>>>>>>>>>>> 暴击几率相关 >>>>>>>>>>>>>>>>>>>>>>>>
		"critical_hit_rate":
			match change_type:
				"percent":
					critical_hit_rate += base_critical_hit_rate * value
				"absolute":
					critical_hit_rate += value
# >>>>>>>>>>>>>>>>>>>>> 暴击伤害相关 >>>>>>>>>>>>>>>>>>>>>>>>
		"critical_damage":
			match change_type:
				"percent":
					critical_damage += base_critical_damage * value
				"absolute":
					critical_damage += value
# >>>>>>>>>>>>>>>>>>>>> 子弹数目相关 >>>>>>>>>>>>>>>>>>>>>>>>
		"number_of_projectiles":
			match change_type:
				"percent":
					number_of_projectiles += base_number_of_projectiles * value
					magazine += base_magazine * value
				"absolute":
					number_of_projectiles += value
					magazine += value
# >>>>>>>>>>>>>>>>>>>>> 飞行速度相关 >>>>>>>>>>>>>>>>>>>>>>>>
		"speed_fly":
			match change_type:
				"percent":
					speed_fly += base_speed_fly * value
				"absolute":
					speed_fly += value
# >>>>>>>>>>>>>>>>>>>>> 穿透率相关 >>>>>>>>>>>>>>>>>>>>>>>>
		"penetration_rate":
			match change_type:
				"percent":
					penetration_rate += base_penetration_rate * value
				"absolute":
					penetration_rate += value


# >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> 状态机 >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
enum State {
	WAIT,
	ATTACK,
	BACK
}

#func tick_physics(state: State, delta: float) -> void:
	#match state:
		#State.WAIT:
			#rotation = lerp_angle(rotation, PI/2, *delta)
			#position = slot.global_position
		#State.ATTACK:
			#var dir = (target.global_position - position).normalized()
			#rotation = lerp_angle(rotation, dir.angle(), speed_rotation*delta)
			#position = position.move_toward(target.global_position, speed_fly*delta)
		#State.BACK:
			#rotation = lerp_angle(rotation, PI/2, speed_rotation*delta)
			#position = position.move_toward(slot.global_position, speed_flt*delta)
#
			#
#func get_next_state(state: State) -> int:
	#match state:
		#State.WAIT:
			#target = Tools.get_nearest_enemy(attack_range, enemies, global_position)
			#if target and attack_wait_timer.is_stopped():
				#return State.ATTACK
		#State.ATTACK:
			#if not target or position.distance_to(target.global_position) < 1.0:
				#return State.BACK
		#State.BACK:
			#if position.distance_to(slot.global_position) < 1.0:
				#return State.WAIT
				#
	#return StateMachine.KEEP_CURRENT
	#
#func transition_state(from: State, to: State) -> void:	
	## print("[%s] %s => %s" % [
	## 	Engine.get_physics_frames()	,
	## 	State.keys()[from] if from != -1 else "<START>",
	## 	State.keys()[to],
	## ])
#
	#match to:
		#State.WAIT:
			#attack_wait_timer.start()
		#State.ATTACK:
			#hit_box.monitoring = true
		#State.BACK:
			#hit_box.monitoring = false

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("enemy") and not enemies.has(body):
		enemies.append(body)

func _on_area_2d_body_exited(body: Node2D) -> void:
	if body.is_in_group("enemy") and enemies.has(body):
		enemies.erase(body)

