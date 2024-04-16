extends Node

var current_combat_progress 

func _ready() -> void:
		CombatProgressGenerator.connect("update_combat_progress", _on_update_combat_progress)
		
func update(selected_node: CombatProgressGenerator.CombatNode, selected: bool) -> void:
	var vec_index: Vector2i = get_combat_node_index(selected_node)
	if selected:
		for node in current_combat_progress[vec_index.x]:
			if node == selected_node:
				node.selected = true
			for connection in node.connections:
				print("connection: ", connection)
				connection.activate = true
			else:
				node.selected = false

	else:
		pass

	
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
	current_combat_progress = nodes
