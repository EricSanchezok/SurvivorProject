class_name Enemy
extends CharacterBody2D

@onready var enemy_stats: EnemyStats = $EnemyStats
@onready var graphics: Node2D = $Graphics
@onready var state_machine: Node = $StateMachine
@onready var hit_box: Area2D = $Graphics/HitBox
@onready var hurt_box: Area2D = $Graphics/HurtBox
@onready var animation_player: AnimationPlayer = $AnimationPlayer

enum Direction {
	LEFT = -1,
	RIGHT = +1,
}

enum State {
	APPEAR,
	RUN,
	DIE
}

var pending_damage: Damage


@export var direction := Direction.LEFT:
	set(v):
		direction = v
		if not is_node_ready():
			await  ready
		graphics.scale.x = direction

var random := RandomNumberGenerator.new()

func _ready() -> void:
	random.randomize()
	
func die() -> void:
	queue_free()
	
	
func tick_physics(state: State, delta: float) -> void:

	match state:
		State.APPEAR, State.DIE:
			pass
		State.RUN:
			move(delta)

	
func find_players(node):
    var players = []
    if node is Player:
        players.append(node)
    for child in node.get_children():
        players += find_players(child)
    return players

var players = find_players(get_tree().get_root())
# 现在players变量包含了所有Player实例
for player in players:
    print(player.name)  # 或者进行其他操作

	
	
func get_next_state(state: State) -> int:
	if enemy_stats.health == 0:
		return StateMachine.KEEP_CURRENT if state == State.DIE else State.DIE
	
	match state:
		State.APPEAR:
			if not animation_player.is_playing():
				return State.RUN
		State.RUN:
			pass
		State.DIE:
			pass
				
	return StateMachine.KEEP_CURRENT
	
func transition_state(from: State, to: State) -> void:
	
	#print("[%s] %s => %s" % [
		#Engine.get_physics_frames()	,
		#State.keys()[from] if from != -1 else "<START>",
		#State.keys()[to],
	#])
	
	match to:
		State.APPEAR:
			animation_player.play("appear")
		State.RUN:
			animation_player.play("run")
		State.DIE:
			# 关闭 hurt_box
			hurt_box.monitorable = false
			
			die()

