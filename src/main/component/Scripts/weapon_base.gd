class_name WeaponBase
extends CharacterBody2D

var enemies: Array = []
var slot: Marker2D
var player: CharacterBody2D
var player_stats: Node

@export var search_radius: float = 100.0:
	set(v):
		search_radius = v
		$SearchBox/CollisionShape2D.shape.radius = search_radius
		
@export var time_cooldown: float = 1.0:
	set(v):
		time_cooldown = v
		$TimerCoolDown.wait_time = time_cooldown
		
func get_nearest_enemy() -> CharacterBody2D:
	'''
	获取最近的敌人
	
	:return: 最近的敌人
	'''
	var nearestEnemy: CharacterBody2D = null
	var nearestDistance: float = pow(search_radius, 2)
	for enemy in enemies:
		var distance = enemy.global_position.distance_squared_to(global_position)
		if distance < nearestDistance:
			nearestEnemy = enemy
			nearestDistance = distance
	return nearestEnemy
	
func get_random_enemy() -> CharacterBody2D:
	return enemies.pick_random()

func _on_search_box_body_entered(body: Node2D) -> void:
	if body.is_in_group("enemy") and not enemies.has(body):
		enemies.append(body)

func _on_search_box_body_exited(body: Node2D) -> void:
	if body.is_in_group("enemy") and enemies.has(body):
		enemies.erase(body)
