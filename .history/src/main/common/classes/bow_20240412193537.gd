class_name Bow
extends Node2D


@onready var area_2d: Area2D = $Area2D
@onready var graphics: Node2D = $Graphics
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var attack_wait_timer: Timer = $AttackWaitTimer
@onready var marker_2d: Marker2D = $Marker2D


@export var base_physical_attack_power: float = 0.5
@export var base_magic_attack_power: float = 0.0
@export var base_attack_range: float = 500.0 # 自动索敌的范围
@export var base_attack_speed: float = 200.0
@export var base_attack_wait_time: float = 0.5
@export var base_knockback: float = 30.0

var physical_attack_power: float = base_physical_attack_power
var magic_attack_power: float = base_magic_attack_power
var attack_range: float = base_attack_range
var attack_speed: float = base_attack_speed
var attack_wait_time: float = base_attack_wait_time
var knockback: float = base_knockback

var enemies: Array = []

var damage: float = 0.0