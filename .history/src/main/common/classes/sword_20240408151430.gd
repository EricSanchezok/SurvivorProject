class_name Sword
extends Node2D

# Constants for attack properties
@export var physical_attack_power: float = 3.0
@export var magic_attack_power: float = 0.5
@export var attack_range: float = 50.0
@export var attack_windup_speed: float = 200.0
@export var attack_backswing_speed: float = 100.0
@export var attack_wait_time: float = 0.5
@export var knockback: float = 20.0

# Nodes and state
@onready var area2D: Area2D = $Area2D
@onready var parentNode: Node2D = get_parent()
@onready var attack_wait_timer: Timer = $AttackWaitTimer

var enemies: Array = []
var isAttacking: bool = false
var target: CharacterBody2D = null

# Attack timing
var isWindupPhase: bool = false
var isBackswingPhase: bool = false

var isBezier: bool = true

func _ready() -> void:
	# Set the area2D scale to the attack range
	area2D.scale = Vector2(attack_range/10.0, attack_range/10.0)

	attack_wait_timer.wait_time = attack_wait_time


func _process(delta: float) -> void:
	if not isAttacking and attack_wait_timer.is_stopped():
		target = get_nearest_enemy()
		if target:
			start_attack()

	if isWindupPhase:
		perform_windup(delta)
	elif isBackswingPhase:
		perform_backswing(delta)

func start_attack() -> void:
	isAttacking = true
	isWindupPhase = true
	isBackswingPhase = false

func perform_windup(delta: float) -> void:
	var targetDirection = (target.global_position - global_position).normalized()
	rotation = lerp_angle(rotation, targetDirection.angle()-PI/2, 0.07)

	var distanceToTarget = global_position.distance_to(target.global_position)
	var totalTime = distanceToTarget / attack_windup_speed

	if totalTime > 0.01:
		move_toward_target(target.global_position, delta)
	else:
		transition_to_backswing()

func perform_backswing(delta: float) -> void:
	rotation = lerp_angle(rotation, parentNode.rotation, 0.15)

	var distanceToParent = global_position.distance_to(parentNode.global_position)
	var totalTime = distanceToParent / attack_backswing_speed

	if totalTime > 0.01:
		move_toward_target(parentNode.global_position, delta)
	else:
		end_attack()

func move_toward_target(targetPos: Vector2, delta: float) -> void:
	var speed = attack_windup_speed if isWindupPhase else attack_backswing_speed
	if not isBezier:
		var movementStep = speed * delta
		global_position = global_position.move_toward(targetPos, movementStep)
	else:
		var movementStep = speed * delta
		var direction = Vector2(cos(rotation + PI/2), sin(rotation + PI/2)) if isWindupPhase else Vector2(cos(rotation), sin(rotation))
		var startControlPoint = global_position + direction * 1.7
		var t = 0.0
		while true:
			var nP := global_position.bezier_interpolate(startControlPoint, targetPos, targetPos, t)
			var distance := global_position.distance_to(nP)
			if distance > movementStep:
				break
			t += 0.01
		var nextPoint = global_position.bezier_interpolate(startControlPoint, targetPos, targetPos, t)
		global_position = global_position.move_toward(nextPoint, speed * delta)

func transition_to_backswing() -> void:
	isWindupPhase = false
	isBackswingPhase = true

func end_attack() -> void:
	isBackswingPhase = false
	isAttacking = false
	attack_wait_timer.start()

func get_nearest_enemy() -> CharacterBody2D:
	var nearestEnemy: CharacterBody2D = null
	var nearestDistance: float = attack_range
	for enemy in enemies:
		var distance = area2D.global_position.distance_to(enemy.global_position)
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


# class_name Sword
# extends Node2D

# # 基础物理攻击力
# @export var physical_attack_power: float = 3.0
# # 基础魔法攻击力
# @export var magic_attack_power: float = 0.5
# # 基础攻击范围
# @export var attack_range: float = 100.0
# # 基础攻击速度(武器飞行的速度)
# @export var attack_speed: float = 100.0
# # 基础击退
# @export var knockback: float = 20.0


# @onready var area_2d: Area2D = $Area2D
# @onready var parent_node: Node2D = get_parent()

# var enemies: Array = []
# var is_attacking: bool = false
# var target: CharacterBody2D = null

# var current_time: float = 0.0
# var attack_windup: bool = false
# var attack_backswing: bool = false

# var init = false

# func _process(delta: float) -> void:
# 	if not is_attacking and not init:
# 		target = get_nearst_enemy()
# 		if target:
# 			init = true
# 			current_time = 0.0
# 			is_attacking = true
# 			attack_windup = true
# 			attack_backswing = false
# 	if attack_windup:
# 		current_time += delta

# 		var direction = Vector2(cos(rotation + PI/2), sin(rotation + PI/2))
# 		var target_direction := (target.global_position - global_position).normalized()
# 		rotation = lerp_angle(rotation, target_direction.angle() - PI/2, 0.07)

# 		var distance = global_position.distance_to(target.global_position)
# 		var all_time = distance / attack_speed
# 		var t = min(current_time / all_time, 1.0)
# 		if t < 1.0:
# 			var start_control_point = global_position + direction * 1.7
# 			var next_point = global_position.bezier_interpolate(start_control_point, target.global_position, target.global_position, t)
# 			global_position = global_position.move_toward(next_point, attack_speed * delta)
# 		else:
# 			current_time = 0.0
# 			attack_windup = false
# 			attack_backswing = true
# 	elif attack_backswing:
# 		current_time += delta
# 		var direction = Vector2(cos(rotation + PI/2), sin(rotation + PI/2))
# 		rotation = lerp_angle(rotation, 0.0, 0.15)

# 		var distance = global_position.distance_to(parent_node.global_position)
# 		var all_time = distance / attack_speed
# 		var t = min(current_time / all_time, 1.0)
# 		if t < 1.0:
# 			var start_control_point = global_position + direction * 2.0
# 			var next_point = global_position.bezier_interpolate(start_control_point, parent_node.global_position, parent_node.global_position, t)
# 			global_position = global_position.move_toward(next_point, attack_speed * delta)
# 		else:
# 			current_time = 0.0
# 			attack_backswing = false
# 			is_attacking = false


	


# func get_nearst_enemy() -> CharacterBody2D:
# 	'''
# 	获取最近的敌人
	
# 	:return: CharacterBody2D 最近的敌人
# 	'''
# 	var nearst_enemy: CharacterBody2D = null
# 	var nearst_distance: float = attack_range
# 	for enemy in enemies:
# 		var distance = area_2d.global_position.distance_to(enemy.global_position)
# 		if distance < nearst_distance:
# 			nearst_enemy = enemy
# 			nearst_distance = distance
# 	return nearst_enemy

# func _on_area_2d_body_entered(body: Node2D) -> void:
# 	if body.is_in_group('enemy') and not enemies.has(body):
# 		enemies.append(body)

# func _on_area_2d_body_exited(body: Node2D) -> void:
# 	if body.is_in_group('enemy') and enemies.has(body):
# 		enemies.erase(body)
		
