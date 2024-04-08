extends Node2D

@onready var hit_box: HitBox = $Graphics/HitBox
@onready var area_2d: Area2D = $Area2D

# 基础属性
@export var base_physical_attack_power: float = 2.0
@export var base_magic_attack_power: float = 0.0
@export var base_attack_range: float = 50.0
@export var base_attack_speed: float = 300.0
@export var base_attack_distance: float = 30.0
@export var base_rotation_speed: float = 0.6
@export var base_attack_wait_time: float = 0.2
@export var base_knockback: float = 5.0

# 当前属性
var physical_attack_power: float = base_physical_attack_power
var magic_attack_power: float = base_magic_attack_power
var attack_range: float = base_attack_range
var attack_speed: float = base_attack_speed
var attack_distance: float = base_attack_distance
var rotation_speed: float = base_rotation_speed
var attack_wait_time: float = base_attack_wait_time
var knockback: float = base_knockback

var enemies: Array = []
var target: CharacterBody2D = null
var appearPos: Vector2 = Vector2()

var damage: float = 0.0


enum State {
	WAIT,
	CALCULATE,
	APPEAR,
	DISAPPEAR,
	ATTACK,
    BACKWARD
}


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
		State.APPEAR:
			var movementStep = attack_speed * delta
			global_position = global_position.move_toward(target.global_position, movementStep)
		State.DISAPPEAR:
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
		State.APPEAR:
			pass
		State.DISAPPEAR:
			pass
		State.ATTACK:
			pass
		State.FOWRARD:
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
				var targetPos = target.global_position
                appearPos = targetPos + Vector2(rand_range(-attack_distance, attack_distance), rand_range(-attack_distance, attack_distance))
			elif from == State.FORWARD or from == State.ATTACK:
				pass
			hit_box.monitoring = false
		State.APPEAR:
			pass
		State.DISAPPEAR:
			pass
		State.ATTACK:
			pass
		State.FOWRARD:
			pass
		State.BACKWARD:
			pass



