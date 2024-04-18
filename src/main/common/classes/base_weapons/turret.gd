class_name Turret
extends Node2D

# >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> 武器基类 >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
var slot: Node2D
var player: CharacterBody2D
var playerStats: Node

# >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> 节点引用 >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
@onready var searching_shape_2d: CollisionShape2D = $Area2D/CollisionShape2D
@onready var graphics: Node2D = $Graphics
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var attack_wait_timer: Timer = $AttackWaitTimer
@onready var marker_2d: Marker2D = $Marker2D

# >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> 基础属性 >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
@export var base_physical_attack_power: float = 0.0  #物理攻击力
@export var base_magic_attack_power: float = 3.0   #魔法攻击力
@export var base_attack_range: float = 150.0 #自动索敌的范围
@export var base_attack_speed: float = 300.0  #攻击速度
@export var base_rotation_speed: float = 15.0   #旋转速度
@export var base_attack_wait_time: float = 1.5   #攻击间隔
@export var base_knockback: float = 30.0    #击退效果
@export var base_critical_hit_rate: float = 0.0  #暴击率
@export var base_critical_damage: float = 1.5    #暴击伤害
@export var base_number_of_projectiles: int = 1   #发射物数量
@export var base_projectile_speed: float = 200.0   #发射物速度

# >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> 当前属性 >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
var physical_attack_power: float
var magic_attack_power: float
var damage: float = 0.0 # 能够造成的总伤害
var attack_range: float
var attack_speed: float
var rotation_speed: float
var attack_wait_time: float
var knockback: float
var critical_hit_rate: float
var critical_damage: float
var number_of_projectiles: int
var projectile_speed: float

# >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> 特殊属性 >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
@export var base_explosion_range: = 0   #爆炸范围
@export var base_penetration_rate: = 0  #穿透率
var explosion_range: float 
var penetration_rate: float = base_penetration_rate

# >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> 变量定义 >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
@onready var bullets = {
	"normal_shell": preload("res://src/main/scene/role/weapons/Bullet/normal_shell.tscn"),
}
var enemies: Array = []
var bullet_count:float = 0 #子弹计数器
var target: CharacterBody2D = null
var targetInitialPos: Vector2 = Vector2()


func _ready() -> void:
	'''
	初始化武器

	:return: void
	'''
	_update_parameters()
	playerStats.connect("stats_changed", _on_stats_changed)



func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("enemy") and not enemies.has(body):
		enemies.append(body)


func _on_area_2d_body_exited(body: Node2D) -> void:
	if body.is_in_group("enemy") and enemies.has(body):
		enemies.erase(body)

# >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> 参数更新 >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
func _update_parameters() -> void:
	'''
	更新武器的属性

	:return: void
	'''
	physical_attack_power = base_physical_attack_power * playerStats.physical_attack_power_multiplier * playerStats.attack_power_multiplier
	magic_attack_power = base_magic_attack_power * playerStats.magic_attack_power_multiplier * playerStats.attack_power_multiplier
	damage = physical_attack_power + magic_attack_power
	attack_range = base_attack_range * playerStats.attack_range_multiplier
	searching_shape_2d.shape.radius = attack_range
	attack_speed = base_attack_speed * playerStats.attack_speed_multiplier
	animation_player.speed_scale = playerStats.attack_speed_multiplier
	rotation_speed = base_rotation_speed * playerStats.attack_speed_multiplier
	attack_wait_time = base_attack_wait_time / playerStats.attack_speed_multiplier
	attack_wait_timer.wait_time = attack_wait_time
	knockback = base_knockback * playerStats.knockback_multiplier
	critical_hit_rate=base_critical_hit_rate + playerStats.critical_hit_rate
	critical_damage = base_critical_damage + playerStats.critical_damage
	number_of_projectiles=base_number_of_projectiles + playerStats.number_of_projectiles
	projectile_speed = base_projectile_speed * playerStats.projectile_speed_multiplier
	
	explosion_range = base_explosion_range * playerStats.attack_range_multiplier


func _on_stats_changed() -> void:
	_update_parameters()

# >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> 状态机 >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
enum State {
	APPEAR,
	WAIT,
	FIRE,
}

func tick_physics(state: State, delta: float) -> void:
	target = Tools.get_nearest_enemy(attack_range, enemies, global_position)
	
	match state:
		State.APPEAR:
			pass
		State.WAIT:
			pass
		State.FIRE:
			pass
			
func get_next_state(state: State) -> int:
	match state:
		State.APPEAR:
			if not animation_player.is_playing():
				return State.WAIT
		State.WAIT:
			if target and attack_wait_timer.is_stopped(): 
				targetInitialPos = target.position
				return State.FIRE
		State.FIRE:
			if not animation_player.is_playing():
				return State.WAIT
				
	return StateMachine.KEEP_CURRENT
	
func transition_state(from: State, to: State) -> void:
	#print("[%s] %s => %s" % [Engine.get_physics_frames(),State.keys()[from] if from != -1 else "<START>",State.keys()[to],]) 
	
	match to:
		State.APPEAR:
			var turret_generator = get_tree().root.get_node("bg_map/turretGenerator")
			position = turret_generator.get_random_position()
			animation_player.play("appear")
		State.WAIT:
			pass
		State.FIRE:
			animation_player.play("fire")

func shoot() ->void:
	var now_bullet = bullets["normal_shell"].instantiate()
	now_bullet.projectile_speed = projectile_speed
	now_bullet.damage = damage
	now_bullet.knockback = knockback
	now_bullet.penetration_rate = penetration_rate
	now_bullet.explosion_range = explosion_range
	now_bullet.position = marker_2d.global_position
	now_bullet.target = target
	now_bullet.targetInitialPos = targetInitialPos
	get_tree().root.add_child(now_bullet)
	attack_wait_timer.start()

