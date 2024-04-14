extends Area2D



var collision_shapes = []  # 创建一个数组来存储找到的 CollisionShape2D 节点

func _ready() -> void:
	for child in get_children():  # 遍历当前节点的所有子节点
		if child is CollisionShape2D:  # 检查子节点是否是 CollisionShape2D 类型
			collision_shapes.append(child)  # 如果是，添加到数组中

	var collision_shape = get_random_shape()
	if collision_shape:
		var pos = get_random_postion_in_shape(collision_shape)
		print("Random position in shape: ", pos)
	else:
		printerr("No CollisionShape2D nodes found")


func get_random_position() -> Vector2:
    '''
    从所有 CollisionShape2D 节点中随机选择一个，然后在该形状内生成一个随机位置。
    '''
	var collision_shape = get_random_shape()
	if collision_shape:
		var pos = get_random_postion_in_shape(collision_shape)
		return pos
	else:
		printerr("No CollisionShape2D nodes found")
		return Vector2.ZERO


# 假设每个 CollisionShape2D 节点都有一个名为 "probability" 的属性
func get_random_shape() -> CollisionShape2D:
    '''
    从所有 CollisionShape2D 节点中随机选择一个，概率与其 "probability" 属性成正比。
    '''
	var total_probability = 0
	for shape in collision_shapes:
		total_probability += shape.probability  # 计算所有 shape 的概率总和

	if total_probability == 0:  # 避免除以零的错误
		return null

	var random_pick = randf() * total_probability  # 在0到总概率之间生成一个随机数

	var cumulative_probability = 0.0
	for shape in collision_shapes:
		cumulative_probability += shape.probability
		if random_pick <= cumulative_probability:  # 检查随机数落在哪个区间
			return shape

	return null  # 如果所有概率加起来没有达到随机数（理论上不应发生），返回 null

func get_random_postion_in_shape(collision_shape: CollisionShape2D) -> Vector2:
    '''
    生成一个在给定 CollisionShape2D 节点内的随机位置。
    该函数假设 CollisionShape2D 节点是 CircleShape2D 或 RectangleShape2D 类型。
    
    collision_shape: CollisionShape2D 节点
    return: 随机位置
    '''
	var shape = collision_shape.shape
	var pos = Vector2.ZERO
	if shape is CircleShape2D:
		var circle = shape as CircleShape2D
		var radius = circle.radius
		var angle = randf() * 2 * PI
		pos = Vector2(cos(angle), sin(angle)) * radius + collision_shape.position
	elif shape is RectangleShape2D:
		var rect = shape as RectangleShape2D
		var x = randf_range(-0.5, 0.5) * rect.size.x
		var y = randf() * rect.size.y * 2 - rect.size.y
		pos = Vector2(x, y) + collision_shape.position
	else:
		printerr("Shape type not supported")
	return pos
