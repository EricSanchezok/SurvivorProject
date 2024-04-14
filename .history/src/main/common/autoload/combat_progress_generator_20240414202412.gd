extends Node

enum NodeType {
	START,
	END,
	NORMAL,
	ELITE,
	MYSTERY,
	TREASURE,
}

class MapNode:
	var type = NodeType.NORMAL
	var connections = []

func generate_map(layers, min_nodes_per_layer, max_nodes_per_layer):
	var nodes = []
	for i in range(layers):
		var layer_nodes = []
		var num_nodes = determine_num_nodes(i, layers, min_nodes_per_layer, max_nodes_per_layer)

		for j in range(num_nodes):
			var node = MapNode.new()
			node.type = determine_node_type(i, layers)
			layer_nodes.append(node)

		nodes.append(layer_nodes)
	return nodes

func determine_num_nodes(layer_index, total_layers, min_nodes_per_layer, max_nodes_per_layer) -> int:
    var first_layer = 0
    var last_layer = total_layers - 1
    var second_layer = 1
    var second_to_last_layer = total_layers - 2

    if layer_index == first_layer or layer_index == last_layer:
        return 1  # 返回对于第一层和最后一层的节点数量
    elif layer_index == second_layer or layer_index == second_to_last_layer:
        return max_nodes_per_layer  # 返回对于第二层和倒数第二层的最大节点数量
    else:
        return randi_range(min_nodes_per_layer, max_nodes_per_layer)  # 其他层随机生成节点数量


func determine_node_type(layer_index, total_layers):
	if layer_index == 0:
		return NodeType.START
	elif layer_index == total_layers - 1:
		return NodeType.END
	else:
		var chance = randf()
		if chance < 0.5:
			return NodeType.NORMAL
		elif chance < 0.75:
			return NodeType.ELITE
		elif chance < 0.9:
			return NodeType.MYSTERY
		else:
			return NodeType.TREASURE

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
