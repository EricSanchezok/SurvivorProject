class_name Test
extends Node2D


@onready var graphics: Node2D = $Graphics
@onready var hit_box: HitBox = $Graphics/HitBox
@onready var timer: Timer = $Timer
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var area_2d: Area2D = $Area2D


enum State {
	APPEAR,
	PREPARED,
	RECOVERING,
	HURT,
}

