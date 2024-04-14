extends Node

enum NodeType {
	NORMAL,
	ELITE,
	MYSTERY,
	TREASURE,
	START,
	END
}

class MapNode:
	var type = NodeType.NORMAL
	var connections = []

func generate_map(layers, min_nodes_per_layer, max_nodes_per_layer):
	var nodes = []
	for i in range(layers):
		var layer_nodes = []
		var num_nodes = 1
		if i == 0 or i == layers - 1:
			num_nodes = 1
		var num_nodes = randi_range(min_nodes_per_layer, max_nodes_per_layer)
		for j in range(num_nodes):
			var node = MapNode.new()
			# 随机指定节点类型，此处根据游戏平衡进行调整
			var chance = randf()
			if chance < 0.5:
				node.type = NodeType.NORMAL
			elif chance < 0.75:
				node.type = NodeType.ELITE
			elif chance < 0.9:
				node.type = NodeType.MYSTERY
			else:
				node.type = NodeType.TREASURE
			layer_nodes.append(node)
		nodes.append(layer_nodes)
	return nodes

func connect_layers(prev_layer, next_layer):
	for prev_node in prev_layer:
		var connection_count = randi() % next_layer.size() + 1  # 确保至少有一个连接
		for i in range(connection_count):
			var next_node = next_layer[randi() % next_layer.size()]
			if next_node not in prev_node.connections:
				prev_node.connections.append(next_node)

func create_game_map(total_layers, min_nodes, max_nodes):
	var map = generate_map(total_layers, min_nodes, max_nodes)
	for i in range(map.size() - 1):
		connect_layers(map[i], map[i + 1])
	return map

func print_map(map):
	for i in range(map.size()):
		print("Layer", i, ":")
		for node in map[i]:
			var conn_ids = []
			for connection in node.connections:
				conn_ids.append(map[i+1].find(connection))  # 使用 find 函数来查找索引
			print("  Node", map[i].find(node), " Type:", node.type, " Connections:", conn_ids)
