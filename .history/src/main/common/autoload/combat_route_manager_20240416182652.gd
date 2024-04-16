extends Node

var current_combat_progress 

func _ready() -> void:
		CombatProgressGenerator.connect("update_combat_progress", _on_update_combat_progress)
		
func update(combat_node: CombatProgressGenerator.CombatNode) -> void:
	print("芜湖")
	pass
	
func get_combat_node_index(combat_node: CombatProgressGenerator.CombatNode) -> Vector2i:
	'''
		获取当前节点在combat_progress中的索引
	'''
	for i in range(current_combat_progress.size()):
		for j in range(current_combat_progress[i].size()):
			if current_combat_progress[i][j] == combat_node:
				return Vector2i(i, j)

func _on_update_combat_progress(nodes: Array) -> void:
	current_combat_progress = nodes
