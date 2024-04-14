extends Area2D





func _ready() -> void:
    var collision_shapes = []  # 创建一个数组来存储找到的 CollisionShape2D 节点
    for child in get_children():  # 遍历当前节点的所有子节点
        if child is CollisionShape2D:  # 检查子节点是否是 CollisionShape2D 类型
            collision_shapes.append(child)  # 如果是，添加到数组中
    return collision_shapes  # 返回包含所有 CollisionShape2D 节点的数组


