extends Node

var current_combat_progress: Array
var current_layer_index: int
var current_route: Array

signal update_current_route

func _ready() -> void:
		CombatProgressGenerator.connect("update_combat_progress", _on_update_combat_progress)


func only_one_way(node: CombatProgressGenerator.CombatNode) -> bool:
	var current_node = node
	while current_node.connections.size() == 1:
		current_node = current_node.connections[0]
	if current_node == current_combat_progress[-1][-1]:
		return true
	return false

func update(selected_node: CombatProgressGenerator.CombatNode, selected: bool) -> void:
	'''
	根据对当前节点的操作，更新所有相关的节点的selected和activate

	:param selected_node: CombatProgressGenerator.CombatNode
	:param selected: bool
	'''
	# 更新节点选择信息
	var vec_index: Vector2i = get_combat_node_index(selected_node)
	if selected:
		for node in current_combat_progress[vec_index.x]:
			if node == selected_node:
				node.selected = true
				for connection in node.connections:
					if connection.type != CombatProgressGenerator.NodeType.END:
						connection.activate = true
			else:
				node.selected = false
				for connection in node.connections:
					if connection not in selected_node.connections:
						connection.activate = false
	else:
		selected_node.selected = false
		for connection in selected_node.connections:
			connection.activate = false
	# 更新当前地图
	current_route.clear()
	for i in range(current_combat_progress.size() - 1):
		if i == 0:
			current_route.append(current_combat_progress[i][0])
		else:
			for j in range(current_combat_progress[i].size()):
				if current_combat_progress[i][j].selected:
					current_route.append(current_combat_progress[i][j])
					# 如果已经到了倒数第二层，直接添加最后一个节点
					if i == current_combat_progress.size() - 2:
						current_route.append(current_combat_progress[i][j])
					break
	#print("-----------------------------------------")
	#var index = 0
	#for node in current_route:
		#print(index, ":", node.type, " ")
		#index += 1
	
func get_combat_node_index(combat_node: CombatProgressGenerator.CombatNode) -> Vector2i:
	'''
	获取当前节点在combat_progress中的索引

	:param combat_node: CombatProgressGenerator.CombatNode
	:return: Vector2i
	'''
	for i in range(current_combat_progress.size()):
		for j in range(current_combat_progress[i].size()):
			if current_combat_progress[i][j] == combat_node:
				return Vector2i(i, j)
	return Vector2i(-1, -1)

func _on_update_combat_progress(nodes: Array) -> void:
	current_layer_index = 0
	current_combat_progress = nodes
	current_route.clear()
	current_route.append(current_combat_progress[0][0])
