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
	var map = []
	for i in range(layers):
		var layer_nodes = []
		var num_nodes = determine_num_nodes(i, layers, min_nodes_per_layer, max_nodes_per_layer)

		for j in range(num_nodes):
			var node = MapNode.new()
			node.type = determine_node_type(i, layers)
			layer_nodes.append(node)

		map.append(layer_nodes)
	return map

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

# Helper function to shuffle and select indices
func shuffle_and_select_indices(size, select_count):
	var selected_indices = []
	while selected_indices.size() < select_count:
		var rand_index = randi() % size
		if not selected_indices.has(rand_index):
			selected_indices.append(rand_index)
	selected_indices.sort()  # 确保顺序连接
	return selected_indices

# Helper function to connect remaining nodes to the closest node
func connect_remaining_nodes(p_layer, n_layer, selected_indices, exclude_same_index=false):
	var max_size = max(p_layer.size(), n_layer.size())
	var min_size = min(p_layer.size(), n_layer.size())
	var p_more = p_layer.size() > n_layer.size()
	for i in range(max_size):
		if not selected_indices.has(i):
			var closest_index = -1
			var min_distance = p_layer.size() + n_layer.size()
			for j in range(min_size):
				if exclude_same_index and i == j:
					continue  # Skip checking same index if required
				var distance = abs(i - j)
				if distance < min_distance:
					min_distance = distance
					closest_index = j
			if closest_index != -1:
				if p_more:
					p_layer[i].connections.append(n_layer[closest_index])
				else:
					p_layer[closest_index].connections.append(n_layer[i])

func connect_layers(prev_layer, next_layer):
	# Case 1: Only one node in the previous layer
	if prev_layer.size() == 1:
		for next_node in next_layer:
			prev_layer[0].connections.append(next_node)
		return

	# Case 2: More nodes in the previous layer than in the next layer
	if prev_layer.size() > next_layer.size():
		var selected_indices = shuffle_and_select_indices(prev_layer.size(), next_layer.size())
		print("prev_layer.size():", prev_layer.size(), "next_layer.size():", next_layer.size(), "selected_indices:", selected_indices)
		for i in range(next_layer.size()):
			prev_layer[selected_indices[i]].connections.append(next_layer[i])
		connect_remaining_nodes(prev_layer, next_layer, selected_indices)

	# Case 3: More nodes in the next layer than in the previous layer
	elif prev_layer.size() < next_layer.size():
		var selected_indices = shuffle_and_select_indices(next_layer.size(), prev_layer.size())
		for i in range(prev_layer.size()):
			prev_layer[i].connections.append(next_layer[selected_indices[i]])
		connect_remaining_nodes(prev_layer, next_layer, selected_indices)

	# Case 4: Same number of nodes, one-to-one connection
	else:
		for i in range(prev_layer.size()):
			prev_layer[i].connections.append(next_layer[i])
		# Optionally: Connect an additional node from prev_layer to a different node in next_layer, excluding same index connections
		connect_remaining_nodes(prev_layer, next_layer, shuffle_and_select_indices(prev_layer.size(), prev_layer.size()-1), true)



# func connect_layers(prev_layer, next_layer):
# 	# 情况1：只有一个前层节点，连接所有后层节点
# 	if prev_layer.size() == 1:
# 		for next_node in next_layer:
# 			prev_layer[0].connections.append(next_node)
# 	else:
# 		# 对于前层节点多于后层节点的情况
# 		if prev_layer.size() > next_layer.size():
# 			# 随机选择与后层相同数量的前层节点
# 			var selected_indices = []  # 存储被选中的节点索引
# 			while selected_indices.size() < next_layer.size():
# 				var rand_index = randi() % prev_layer.size()
# 				if not selected_indices.has(rand_index):
# 					selected_indices.append(rand_index)
# 			selected_indices.sort()  # 确保顺序连接
# 			# 按顺序连接选中的前层节点到后层节点
# 			for i in range(selected_indices.size()):
# 				var prev_node = prev_layer[selected_indices[i]]
# 				var next_node = next_layer[i]
# 				prev_node.connections.append(next_node)
# 			for i in range(prev_layer.size()):
# 				if not selected_indices.has(i):
# 					# 寻找最近的后层节点连接
# 					var closest_index = -1
# 					var min_distance = prev_layer.size() + next_layer.size()  # 设置一个足够大的初始距离
# 					for j in range(next_layer.size()):
# 						var distance = abs(i - j)
# 						if distance < min_distance:
# 							min_distance = distance
# 							closest_index = j
# 					# 连接到最近的后层节点
# 					if closest_index != -1:
# 						prev_layer[i].connections.append(next_layer[closest_index])
# 		elif prev_layer.size() < next_layer.size():
# 			var selected_indices = []
# 			while selected_indices.size() < prev_layer.size():
# 				var rand_index = randi() % next_layer.size()
# 				if not selected_indices.has(rand_index):
# 					selected_indices.append(rand_index)
# 			selected_indices.sort() 
# 			for i in range(selected_indices.size()):
# 				var prev_node = prev_layer[i]
# 				var next_node = next_layer[selected_indices[i]]
# 				prev_node.connections.append(next_node)
# 			for i in range(next_layer.size()):
# 				if not selected_indices.has(i):
# 					var closest_index = -1
# 					var min_distance = prev_layer.size() + next_layer.size()
# 					for j in range(next_layer.size()):
# 						var distance = abs(i - j)
# 						if distance < min_distance:
# 							min_distance = distance
# 							closest_index = j
# 					if closest_index != -1:
# 						prev_layer[closest_index].connections.append(next_layer[i])
# 		else:
# 			for i in range(prev_layer.size()):
# 				prev_layer[i].connections.append(next_layer[i])
# 			# 随机选择一个前层节点连接到另一个后层节点
# 			var rand_index = randi() % prev_layer.size()
# 			var closest_index = -1
# 			var min_distance = prev_layer.size() + next_layer.size()
# 			for j in range(next_layer.size()):
# 				if j != rand_index:
# 					var distance = abs(rand_index - j)
# 					if distance < min_distance:
# 						min_distance = distance
# 						closest_index = j
# 			if closest_index != -1:
# 				prev_layer[rand_index].connections.append(closest_index)

func create_game_map(total_layers, min_nodes, max_nodes):
	var map = generate_map(total_layers, min_nodes, max_nodes)
	for i in range(map.size() - 1):
		connect_layers(map[i], map[i + 1])
	return map

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
