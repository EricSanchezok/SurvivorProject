extends Node

var current_combat_progress 

func _ready() -> void:
		CombatProgressGenerator.connect("update_combat_progress", _on_update_combat_progress)
		
func update(combat_node: CombatProgressGenerator.CombatNode) -> void:
	print("芜湖")
	pass
	
func get_combat_node_index(combat_node: CombatProgressGenerator.CombatNode) -> Vector2i:
	for i 

func _on_update_combat_progress(nodes: Array) -> void:
	current_combat_progress = nodes
