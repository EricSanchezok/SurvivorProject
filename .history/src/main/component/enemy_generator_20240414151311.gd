extends Area2D



var collision_shapes = []  # 创建一个数组来存储找到的 CollisionShape2D 节点

func _ready() -> void:
   
	for child in get_children():  # 遍历当前节点的所有子节点
		if child is CollisionShape2D:  # 检查子节点是否是 CollisionShape2D 类型
			collision_shapes.append(child)  # 如果是，添加到数组中

	print(get_random_shape())  # 打印一个随机的 CollisionShape2D 节点
	


# 假设每个 CollisionShape2D 节点都有一个名为 "probability" 的属性
func get_random_shape() -> CollisionShape2D:
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
