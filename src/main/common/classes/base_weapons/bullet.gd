class_name Bullet
extends CharacterBody2D
# >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> 变量定义 >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
var tracking: bool = false
var penetration_rate: float # 穿透率 0-1
var projectile_speed: float
var knockback: float
var dir1: Vector2
var dir2: Vector2
var damage: float
var explosion_range: float
var target: CharacterBody2D = null
var targetInitialPos: Vector2 = Vector2()
var hit : bool = false

func _ready() -> void:
	dir1 = (target.position - position).normalized()
	velocity = dir1 * projectile_speed



func get_parameters(parent: Node2D) -> void:
	penetration_rate = parent.penetration_rate
	projectile_speed = parent.projectile_speed
	knockback = parent.knockback
	damage = parent.damage
	explosion_range = parent.explosion_range
	
func _on_hit_box_hit(hurtbox: Variant) -> void:
	if not Tools.is_success(penetration_rate):
		queue_free()
	else :
		hit = true


func _on_destruction_timer_timeout() -> void:
	'''
	 	计时器超时后销毁子弹
	'''
	queue_free()


# >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> 状态机 >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
enum State {
	TARGET,
	NOTARGET,
}
func tick_physics(state: State, delta: float) -> void:
	self.look_at(velocity+position)
	move_and_slide()
	
	match state:
		State.TARGET:
			dir2 = (target.position - position).normalized()
			velocity = dir2 * projectile_speed
		State.NOTARGET:
			pass


func get_next_state(state: State) -> int:
	match state:
		State.TARGET:
			if target.enemyStats.health == 0 or hit:
				return State.NOTARGET
		State.NOTARGET:
			pass
			
	return StateMachine.KEEP_CURRENT
	

func transition_state(from: State, to: State) -> void:
	#print("[%s] %s => %s" % [Engine.get_physics_frames(),State.keys()[from] if from != -1 else "<START>",State.keys()[to],]) 
	match to:
		State.TARGET:
			pass
		State.NOTARGET:
			pass
