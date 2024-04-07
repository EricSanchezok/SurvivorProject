class_name EnemyStats
extends Node

signal health_changed

@export var max_health: float = 4
@export var movement_speed: float = 100
@export var attack_power: float = 1.0

@onready var health: float = max_health:
	set(v):
		v = clampf(v, 0, max_health)
		if health == v:
			return
		health = v
		health_changed.emit()
