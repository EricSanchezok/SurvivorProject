extends Node2D

@onready var hit_box: HitBox = $Graphics/HitBox
@onready var area_2d: Area2D = $Area2D

# 基础属性
@export var base_physical_attack_power: float = 2.0
@export var base_magic_attack_power: float = 0.0
@export var base_attack_range: float = 50.0
@export var base_attack_forward_speed: float = 300.0
@export var base_attack_backward_speed: float = 200.0
@export var base_rotation_speed: float = 0.6
@export var base_attack_wait_time: float = 0.2
@export var base_knockback: float = 5.0

# 当前属性
var physical_attack_power: float = base_physical_attack_power
var magic_attack_power: float = base_magic_attack_power
var attack_range: float = base_attack_range
var attack_forward_speed: float = base_attack_forward_speed
var attack_backward_speed: float = base_attack_backward_speed
var rotation_speed: float = base_rotation_speed
var attack_wait_time: float = base_attack_wait_time
var knockback: float = base_knockback

var enemies: Array = []
var target: CharacterBody2D = null
var targetPos: Vector2 = Vector2()

var damage: float = 0.0


enum State {
	WAIT,
	CALCULATE,
	FORWARD,
	ATTACK,
	BACKWARD
}

func move_toward_target(targetPos: Vector2, delta: float) -> void:
	'''
	移动武器朝向目标位置

	:param targetPos: Vector2 目标位置
	:param delta: float 时间间隔
	:return: void
	'''
	var speed = attack_windup_speed if isWindupPhase else attack_backswing_speed
	if not isBezier:
		var movementStep = speed * delta
		global_position = global_position.move_toward(targetPos, movementStep)
	else:
		var movementStep = speed * delta
		var direction = Vector2(cos(rotation + PI/2), sin(rotation + PI/2)) if isWindupPhase else Vector2(cos(rotation), sin(rotation))
		var startControlPoint = global_position + direction * 2.0
		var t = 0.0
		while true:
			var nP := global_position.bezier_interpolate(startControlPoint, targetPos, targetPos, t)
			var distance := global_position.distance_to(nP)
			if distance > movementStep:
				break
			t += 0.01
		var nextPoint = global_position.bezier_interpolate(startControlPoint, targetPos, targetPos, t)
		global_position = global_position.move_toward(nextPoint, speed * delta)

func get_nearest_enemy() -> CharacterBody2D:
	'''
	获取最近的敌人

	:return: CharacterBody2D 最近的敌人
	'''
	var nearestEnemy: CharacterBody2D = null
	var nearestDistance: float = attack_range
	for enemy in enemies:
		var distance = area_2d.global_position.distance_to(enemy.global_position)
		if distance < nearestDistance:
			nearestEnemy = enemy
			nearestDistance = distance
	return nearestEnemy
	

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("enemy") and not enemies.has(body):
		enemies.append(body)


func _on_area_2d_body_exited(body: Node2D) -> void:
	if body.is_in_group("enemy") and enemies.has(body):
		enemies.erase(body)


# >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> 状态机 >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
func tick_physics(state: State, delta: float) -> void:
	match state:
		State.WAIT:
			pass
		State.CALCULATE:
			pass
		State.FORWARD:
			pass
		State.ATTACK:
			pass
		State.BACKWARD:
			pass
			
func get_next_state(state: State) -> int:
	if not target and state != State.WAIT:
		return State.BACKWARD
	match state:
		State.WAIT:
			target = get_nearest_enemy()
			if target:
				return State.CALCULATE
		State.CALCULATE:
			pass
		State.FORWARD:
			pass
		State.ATTACK:
			pass
		State.BACKWARD:
			pass
				
	return StateMachine.KEEP_CURRENT
	
func transition_state(from: State, to: State) -> void:	
	# print("[%s] %s => %s" % [
	# 	Engine.get_physics_frames()	,
	# 	State.keys()[from] if from != -1 else "<START>",
	# 	State.keys()[to],
	# ])

	match to:
		State.WAIT:
			hit_box.monitoring = false
		State.CALCULATE:
			if from == State.WAIT:
				pass
			elif from == State.FORWARD or from == State.ATTACK:
				pass
			hit_box.monitoring = false
		State.FORWARD:
			hit_box.monitoring = true
		State.ATTACK:
			hit_box.monitoring = true
		State.BACKWARD:
			hit_box.monitoring = false



