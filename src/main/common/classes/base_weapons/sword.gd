class_name Sword
extends Node2D

# >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> 武器基类 >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
var slot: Node2D
var player: CharacterBody2D
var playerStats: Node

# >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> 节点引用 >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
@onready var searching_shape_2d: CollisionShape2D = $Area2D/CollisionShape2D
@onready var attack_wait_timer: Timer = $AttackWaitTimer
@onready var hit_box: HitBox = $Graphics/HitBox
@onready var attribute_calculator: AttributeCalculator = $AttributeCalculator
@onready var animation_player: AnimationPlayer = $AnimationPlayer

# >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> 基础属性 >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
@export var base_physical_attack_power: float = 4.0  #物理攻击力
@export var base_magic_attack_power: float = 2.0   #魔法攻击力
@export var base_attack_speed: float = 150.0  #攻击速度
@export var base_attack_windup_speed = 180.0  #攻击时前进速度
@export var base_attack_backswing_speed: float = 120.0 #攻击后收回速度
@export var base_rotation_speed: float = 15.0   #旋转速度
@export var base_attack_range: float = 150.0 #攻击范围
@export var base_explosion_range: = 50   #爆炸范围
@export var base_attack_wait_time: float = 1.5   #攻击间隔
@export var base_knockback: float = 30.0    #击退效果
@export var base_critical_hit_rate: float = 0.0  #暴击率
@export var base_critical_damage: float = 0.0    #暴击伤害
@export var base_number_of_projectiles: int = 1   #发射物数量
@export var base_projectile_speed: float = 200.0   #发射物速度

# >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> 当前属性 >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
var physical_attack_power: float  #物理攻击力
var magic_attack_power: float  #魔法攻击力
var damage: float = 0.0  #总攻击力
var attack_speed: float  #攻击速度
var attack_windup_speed: float  #攻击后收回速度
var attack_backswing_speed: float  #攻击后收回速度
var rotation_speed: float   #旋转速度
var attack_range: float   #攻击范围
var explosion_range: float  #爆炸范围
var attack_wait_time: float  #攻击间隔
var knockback: float  #击退效果
var critical_hit_rate: float  #暴击率
var critical_damage: float  #暴击伤害
var number_of_projectiles: int  #发射物数量
var projectile_speed: float  #发射物速度


# >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> 变量定义 >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
var enemies: Array = []
var target: CharacterBody2D = null

var isBezier: bool = true

func _ready() -> void:
	'''
	初始化

	:return: void
	'''
	# 监听玩家属性节点的属性变化事件，更新武器的属性
	_update_physical_attack_power_changed ()
	_update_magic_attack_power_changed ()
	_update_attack_speed_changed ()
	_update_rotation_speed_changed ()
	_update_attack_range_changed ()
	_update_explosion_range_changed ()
	_update_knockback_changed ()
	_update_critical_hit_rate_changed ()
	_update_critical_damage_changed ()
	_update_number_of_projectiles_changed ()
	_update_projectile_speed_changed ()
	attribute_calculator.connect("physical_attack_power_changed",_on_physical_attack_power_changed)
	attribute_calculator.connect("magic_attack_power_changed",_on_magic_attack_power_changed)
	attribute_calculator.connect("attack_speed_changed",_on_attack_speed_changed)
	attribute_calculator.connect("rotation_speed_changed",_on_rotation_speed_changed)
	attribute_calculator.connect("attack_range_changed",_on_attack_range_changed)
	attribute_calculator.connect("explosion_range_changed",_on_explosion_range_changed)
	attribute_calculator.connect("knockback_changed",_on_knockback_changed)
	attribute_calculator.connect("critical_hit_rate",_on_critical_hit_rate_changed)
	attribute_calculator.connect("critical_damage_changed",_on_critical_damage_changed)
	attribute_calculator.connect("number_of_projectiles",_on_number_of_projectiles_changed)
	attribute_calculator.connect("projectile_speed_changed",_on_projectile_speed_changed)

# >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> 属性更新 >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
# >>>>>>>>>>>>>>>>>>>>> 物理伤害相关 >>>>>>>>>>>>>>>>>>>>>>>>
func  _update_physical_attack_power_changed ()-> void:  
	physical_attack_power = base_physical_attack_power + attribute_calculator.player_physical_attack_power + attribute_calculator.trait_physical_attack_power #物理伤害
	damage = physical_attack_power + magic_attack_power #总伤害

func _on_physical_attack_power_changed() -> void:
	_update_physical_attack_power_changed()
	
# >>>>>>>>>>>>>>>>>>>>> 魔法伤害相关 >>>>>>>>>>>>>>>>>>>>>>>>
func  _update_magic_attack_power_changed ()-> void:
	magic_attack_power = base_magic_attack_power + attribute_calculator.player_magic_attack_power + attribute_calculator.trait_physical_attack_power #魔法伤害
	damage = physical_attack_power + magic_attack_power #总伤害

func _on_magic_attack_power_changed() -> void:
	_update_magic_attack_power_changed()

# >>>>>>>>>>>>>>>>>>>>> 攻击速度相关 >>>>>>>>>>>>>>>>>>>>>>>>
func  _update_attack_speed_changed ()-> void:
	attack_speed = base_attack_speed + attribute_calculator.player_attack_speed + attribute_calculator.trait_attack_speed #攻击速度
	attack_windup_speed =  attack_speed + 30   #攻击时前进速度
	attack_backswing_speed = attack_speed - 30   #攻击后收回速度
	animation_player.speed_scale = attack_speed/base_attack_speed

func _on_attack_speed_changed() -> void:
	_update_attack_speed_changed()

# >>>>>>>>>>>>>>>>>>>>> 旋转速度相关 >>>>>>>>>>>>>>>>>>>>>>>>
func  _update_rotation_speed_changed ()-> void:
	rotation_speed = base_rotation_speed + attribute_calculator.player_rotation_speed + attribute_calculator.trait_rotation_speed #攻击速度

func _on_rotation_speed_changed() -> void:
	_update_rotation_speed_changed()

# >>>>>>>>>>>>>>>>>>>>> 攻击范围相关 >>>>>>>>>>>>>>>>>>>>>>>>
func  _update_attack_range_changed ()-> void:
	attack_range = base_attack_range + attribute_calculator.player_attack_range + attribute_calculator.trait_attack_range #攻击范围
	searching_shape_2d.shape.radius = attack_range  #索敌范围

func _on_attack_range_changed() -> void:
	_update_attack_range_changed()

# >>>>>>>>>>>>>>>>>>>>> 爆炸范围相关 >>>>>>>>>>>>>>>>>>>>>>>>
func  _update_explosion_range_changed ()-> void:
	explosion_range = base_explosion_range + attribute_calculator.player_explosion_range + attribute_calculator.trait_explosion_range #爆炸范围

func _on_explosion_range_changed() -> void:
	_update_explosion_range_changed()
	
# >>>>>>>>>>>>>>>>>>>>> 击退相关 >>>>>>>>>>>>>>>>>>>>>>>>
func  _update_knockback_changed ()-> void:
	knockback = base_knockback + attribute_calculator.player_knockback + attribute_calculator.trait_knockback #击退效果

func _on_knockback_changed() -> void:
	_update_knockback_changed()

# >>>>>>>>>>>>>>>>>>>>> 暴击几率相关 >>>>>>>>>>>>>>>>>>>>>>>>
func  _update_critical_hit_rate_changed ()-> void:
	critical_hit_rate = base_critical_hit_rate + attribute_calculator.player_critical_hit_rate + attribute_calculator.trait_critical_hit_rate #暴击率

func _on_critical_hit_rate_changed() -> void:
	_update_critical_hit_rate_changed()

# >>>>>>>>>>>>>>>>>>>>> 暴击伤害相关 >>>>>>>>>>>>>>>>>>>>>>>>
func  _update_critical_damage_changed ()-> void:
	critical_damage = base_critical_damage + attribute_calculator.player_critical_damage + attribute_calculator.trait_critical_damage #暴击伤害

func _on_critical_damage_changed() -> void:
	_update_critical_damage_changed()

# >>>>>>>>>>>>>>>>>>>>> 子弹数目相关 >>>>>>>>>>>>>>>>>>>>>>>>
func  _update_number_of_projectiles_changed ()-> void:
	number_of_projectiles = base_number_of_projectiles + attribute_calculator.player_number_of_projectiles + attribute_calculator.trait_number_of_projectiles #发射物数量

func _on_number_of_projectiles_changed() -> void:
	_update_number_of_projectiles_changed()

# >>>>>>>>>>>>>>>>>>>>> 子弹速度相关 >>>>>>>>>>>>>>>>>>>>>>>>
func  _update_projectile_speed_changed ()-> void:
	projectile_speed = base_projectile_speed + attribute_calculator.player_projectile_speed + attribute_calculator.trait_projectile_speed #发射物速度

func _on_projectile_speed_changed() -> void:
	_update_projectile_speed_changed()



# >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> 状态机 >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
enum State {
	WAIT,
	ATTACK,
	BACK
}

func tick_physics(state: State, delta: float) -> void:
	match state:
		State.WAIT:
			rotation = lerp_angle(rotation, PI/2, rotation_speed*delta)
			position = slot.global_position
		State.ATTACK:
			var dir = (target.global_position - position).normalized()
			rotation = lerp_angle(rotation, dir.angle(), rotation_speed*delta)
			position = position.move_toward(target.global_position, attack_windup_speed*delta)
		State.BACK:
			rotation = lerp_angle(rotation, PI/2, rotation_speed*delta)
			position = position.move_toward(slot.global_position, attack_backswing_speed*delta)

			
func get_next_state(state: State) -> int:
	match state:
		State.WAIT:
			target = Tools.get_nearest_enemy(attack_range, enemies, global_position)
			if target and attack_wait_timer.is_stopped():
				return State.ATTACK
		State.ATTACK:
			if not target or position.distance_to(target.global_position) < 1.0:
				return State.BACK
		State.BACK:
			if position.distance_to(slot.global_position) < 1.0:
				return State.WAIT
				
	return StateMachine.KEEP_CURRENT
	
func transition_state(from: State, to: State) -> void:	
	# print("[%s] %s => %s" % [
	# 	Engine.get_physics_frames()	,
	# 	State.keys()[from] if from != -1 else "<START>",
	# 	State.keys()[to],
	# ])

	match to:
		State.WAIT:
			attack_wait_timer.start()
		State.ATTACK:
			hit_box.monitoring = true
		State.BACK:
			hit_box.monitoring = false

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("enemy") and not enemies.has(body):
		enemies.append(body)

func _on_area_2d_body_exited(body: Node2D) -> void:
	if body.is_in_group("enemy") and enemies.has(body):
		enemies.erase(body)

