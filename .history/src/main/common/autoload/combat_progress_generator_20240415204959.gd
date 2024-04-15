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

# >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> 连接节点 >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
func generate_nodes(layers, min_nodes_per_layer, max_nodes_per_layer):
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
	if total_layers < 5:
		return randi_range(min_nodes_per_layer, max_nodes_per_layer)

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




func create_game_map(total_layers, min_nodes, max_nodes):
	var nodes = generate_nodes(total_layers, min_nodes, max_nodes)
	for i in range(nodes.size() - 1):
		connect_layers(nodes[i], nodes[i + 1])
	return nodes

func get_parameters(map) -> Vector2i:
	var max_layers = len(map)
	var max_nodes_in_layer = 0

	for layer in map:
		var layer_size = layer.size()
		if layer_size > max_nodes_in_layer:
			max_nodes_in_layer = layer_size

	return Vector2i(max_layers, max_nodes_in_layer)

func print_map(map):
	for i in range(map.size()):
		print("Layer", i, ":")
		for node in map[i]:
			var conn_ids = []
			for connection in node.connections:
				conn_ids.append(map[i+1].find(connection))  # 使用 find 函数来查找索引
			print("  Node", map[i].find(node), " Type:", node.type, " Connections:", conn_ids)



# >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> 连接节点 >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
func shuffle_and_select_indices(size, select_count):
	var selected_indices = []
	while selected_indices.size() < select_count:
		var rand_index = randi() % size
		if not selected_indices.has(rand_index):
			selected_indices.append(rand_index)
	selected_indices.sort()  # 确保顺序连接
	return selected_indices

func connect_remaining_nodes(p_layer, n_layer, selected_indices, exclude_same_index=false):
	var max_size = max(p_layer.size(), n_layer.size())
	var min_size = min(p_layer.size(), n_layer.size())
	var p_more = p_layer.size() > n_layer.size()
	for i in range(max_size):
		if not selected_indices.has(i):
			var closest_index = -1
			var min_distance = 2
			for j in range(min_size):
				if exclude_same_index and i == j:
					continue
				var distance = abs(float(i)/float(max_size) - float(j)/float(min_size)) if p_more else abs(float(j)/float(min_size) - float(i)/float(max_size))
				if distance < min_distance:
					min_distance = distance
					closest_index = j
			if closest_index != -1:
				if p_more:
					p_layer[i].connections.append(n_layer[closest_index])
				else:
					p_layer[closest_index].connections.append(n_layer[i])

func connect_layers(prev_layer, next_layer):
	# Case 1: 只有一个节点
	if prev_layer.size() == 1:
		for next_node in next_layer:
			prev_layer[0].connections.append(next_node)
		return
	# Case 2: 前节点比后节点多
	if prev_layer.size() > next_layer.size():
		var selected_indices = shuffle_and_select_indices(prev_layer.size(), next_layer.size())
		for i in range(next_layer.size()):
			prev_layer[selected_indices[i]].connections.append(next_layer[i])
		connect_remaining_nodes(prev_layer, next_layer, selected_indices)
	# Case 3: 后节点比前节点多
	elif prev_layer.size() < next_layer.size():
		var selected_indices = shuffle_and_select_indices(next_layer.size(), prev_layer.size())
		for i in range(prev_layer.size()):
			prev_layer[i].connections.append(next_layer[selected_indices[i]])
		connect_remaining_nodes(prev_layer, next_layer, selected_indices)
	# Case 4: 前后节点数量相等
	else:
		for i in range(prev_layer.size()):
			prev_layer[i].connections.append(next_layer[i])
		connect_remaining_nodes(prev_layer, next_layer, shuffle_and_select_indices(prev_layer.size(), prev_layer.size()-1), true)