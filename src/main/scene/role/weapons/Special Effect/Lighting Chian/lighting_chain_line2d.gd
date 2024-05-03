extends Line2D

var Arc:int = 10 # 电弧，电段扭曲次数
var RandRange = 10 # 随机偏移幅度
var Division = 10 # 随机分裂次数
var LightingPath:Array # 闪电路径 
var LightSpeed = 0.002 # 闪电速度

var Division1:Array # 分割路径1


func _ready():
	set_lighting()
	pass

func _process(delta):
	#set_lighting()
	#LightingPath.append(owner.current_target.global_position)
	#for N in (Arc-2):
		#LightingPath.append(LightingPath.back()+((owner.next_target.global_position-LightingPath.back())/(Arc-N-1))-Vector2(randf_range(-RandRange,RandRange), randf_range(-RandRange,RandRange)))
		#if LightSpeed != 0: 
			#await get_tree().create_timer(LightSpeed / Engine.time_scale)
	#LightingPath.append(owner.next_target.global_position)
	self.points = LightingPath
	#LightingPath.clear()
	if $"../Timer".is_stopped():
		owner.queue_free()

func set_lighting():
	#self.modulate = Color(1,1,1,1) # 恢复透明度
	LightingPath.clear() # 清空闪电路径点
	#
	## 从电弧段数中制造分段中的随机位置，每N次靠近B点
	LightingPath.append(owner.current_target.global_position)
	
	# 逐段加入电点位置
	for N in (Arc - 2):
		LightingPath.append(LightingPath.back()+((owner.next_target.global_position-LightingPath.back())/(Arc-N-1))-Vector2(randf_range(-RandRange,RandRange), randf_range(-RandRange,RandRange)))
		if LightSpeed != 0: 
			await get_tree().create_timer(LightSpeed / Engine.time_scale)
	
	LightingPath.append(owner.next_target.global_position)
	$"../HitBox".position = owner.next_target.global_position
	
	#### 消失
	#await get_tree().create_timer(0.05)
	#var disappear = $LightBom
	#disappear.interpolate_property(self, "modulate", Color(1,1,1,1), Color(0,0,0,1), 0.5, Tween.TRANS_LINEAR, Tween.TRANS_LINEAR)
	#disappear.start()
###
	##闪烁
	#await get_tree().create_timer(0.2)
	#var lightA = $LightBom
	#lightA.interpolate_property(self, "modulate", Color(50,40,40,1), Color(1,1,1,1), 0.3, Tween.TRANS_LINEAR, Tween.TRANS_LINEAR)
	#lightA.start()
	##SoundsMain.add_SE($PosB.global_position, "闪电", 2, randf_range(0.5,1.3))
###
	## 消失
	#await get_tree().create_timer(0.1)
	#disappear.interpolate_property(self, "modulate", Color(1,1,1,1), Color(0,0,0,1), 1, Tween.TRANS_LINEAR, Tween.TRANS_LINEAR)
	#disappear.start()

#func _on_Timer_timeout():
	#set_lighting()
