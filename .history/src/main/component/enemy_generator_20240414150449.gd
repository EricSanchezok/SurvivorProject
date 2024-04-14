extends Area2D



var collision_shapes = []  # 创建一个数组来存储找到的 CollisionShape2D 节点

func _ready() -> void:
   
	for child in get_children():  # 遍历当前节点的所有子节点
		if child is CollisionShape2D:  # 检查子节点是否是 CollisionShape2D 类型
			collision_shapes.append(child)  # 如果是，添加到数组中

	print(collision_shapes)  # 打印数组中的所有 CollisionShape2D 节点
	


func get_random_shape() -> CollisionShape2D:
    
    if collision_shapes.size() == 0:  # 如果数组为空
        return null  # 返回 null

    var random_index = randi() % collision_shapes.size()  # 生成一个随机索引
    return collision_shapes[random_index]  # 返回数组中的随机 CollisionShape2D 节点