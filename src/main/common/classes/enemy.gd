class_name Enemy
extends CharacterBody2D

enum Direction {
	LEFT = -1,
	RIGHT = +1,
}

var pending_damage: Damage

@export var direction := Direction.LEFT:
	set(v):
		direction = v
		if not is_node_ready():
			await  ready
		graphics.scale.x = direction
		
@export var max_speed: float = 100
@export var acceleration: float = 1500


@onready var graphics: Node2D = $Graphics
@onready var state_machine: Node = $StateMachine
@onready var stats: Node = $Stats
@onready var hit_box: Area2D = $Graphics/HitBox
@onready var hurt_box: Area2D = $Graphics/HurtBox

var random := RandomNumberGenerator.new()

func _ready() -> void:
	random.randomize()
	
func die() -> void:
	queue_free()

func _on_hurt_box_hurt(hitbox: Variant) -> void:
	pending_damage = Damage.new()
	pending_damage.amount = 1
	pending_damage.source = hitbox.owner
		
