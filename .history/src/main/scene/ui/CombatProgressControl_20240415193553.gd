extends Control


# 节点类型颜色定义
var type_colors = {
	CombatProgressGenerator.NodeType.START: Color(0, 1, 0),
	CombatProgressGenerator.NodeType.END: Color(1, 0, 0),
	CombatProgressGenerator.NodeType.NORMAL: Color(0.5, 0.5, 0.5),
	CombatProgressGenerator.NodeType.ELITE: Color(0, 0, 1),
	CombatProgressGenerator.NodeType.MYSTERY: Color(1, 0, 1),
	CombatProgressGenerator.NodeType.TREASURE: Color(1, 1, 0),
}

@onready var h_box_container: HBoxContainer = $VBoxContainer/HBoxContainer/ScrollContainer/HBoxContainer
@onready var scroll_container: ScrollContainer = $VBoxContainer/HBoxContainer/ScrollContainer

var node_button = preload("res://src/main/scene/ui/combat_progress_node_button.tscn")

var container_matrix := []  # 用于存储CenterContainer的二维数组
var container_size :Vector2 = Vector2.ZERO
var lines := []
var lines_base_points := []

func _ready():
	pass

func _process(delta: float) -> void:
	var index := 0
	for line in lines:
		line.points[0] = lines_base_points[index][0] - Vector2(scroll_container.scroll_horizontal, 0)
		line.points[1] = lines_base_points[index][1] - Vector2(scroll_container.scroll_horizontal, 0)
		index += 1

func set_container(map):
	var parameters: Vector2i = CombatProgressGenerator.get_parameters(map)
	var max_layers = parameters[0]
	var max_nodes_in_layer = parameters[1]
	
	container_size.x = 60
	container_size.y = h_box_container.size.y / max_nodes_in_layer

	for x in max_layers:
		var vbox_container = VBoxContainer.new()
		vbox_container.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		vbox_container.custom_minimum_size.x = container_size.x
		vbox_container.add_theme_constant_override("separation", 0)
		h_box_container.add_child(vbox_container)

		var layer = []

		for node in map[x]:
			var center_container = CenterContainer.new()
			#var center_container = AspectRatioContainer.new()
			center_container.size_flags_vertical = Control.SIZE_EXPAND_FILL
			vbox_container.add_child(center_container)
			layer.append(center_container)

		container_matrix.append(layer)

func get_container_position(index_layer: int, index_node: int) -> Vector2:
	var pos_x := index_layer * container_size.x
	var pos_y := index_node * h_box_container.size.y / container_matrix[index_layer].size()
	return Vector2(pos_x, pos_y) + container_matrix[index_layer][index_node].size / 2

func draw_map(map) -> void:
	var parameters: Vector2i = CombatProgressGenerator.get_parameters(map)
	var max_layers = parameters[0]
	var max_nodes_in_layer = parameters[1]

	for index_layer in max_layers:
		for node in map[index_layer]:
			var index = map[index_layer].find(node)
			# var index_container = get_container_index(index, max_nodes_in_layer)
			
			var container = container_matrix[index_layer][index]
			var node_button_instance = node_button.instantiate()
			node_button_instance.node_type = node.type
			container.add_child(node_button_instance)
			
			print(container.global_position)
			
			#for connection in node.connections:
				#var next_index = map[index_layer+1].find(connection)
				## var next_index = get_container_index(map[index_layer+1].find(connection), max_nodes_in_layer)
				#draw_connection(Vector2i(index_layer, index), Vector2i(index_layer+1, next_index))



func get_container_index(index: int, max_nodes_in_layer: int) -> int:
	var mid_point: int = max_nodes_in_layer / 2  # 获取中间点（对于偶数是中间偏左的一个）
	# 奇数节点层处理：直接从中心开始向外扩散
	if max_nodes_in_layer % 2 == 1:
		# 中间索引，然后交替左右展开
		return mid_point + (index % 2) * (index + 1) / 2 - (1 - index % 2) * (index + 1) / 2
	# 偶数节点层处理：从中间偏左的节点开始
	else:
		# 如果索引是偶数，则先向右移动；如果是奇数，则向左移动
		return mid_point + (index + 1) / 2 * (1 - index % 2) - index / 2 * (index % 2)


func draw_connection(index_from: Vector2i, index_to: Vector2i) -> void:
	var pos_from = get_container_position(index_from.x, index_from.y)
	var pos_to = Vector2(index_to.x * container_size.x, index_to.y * 56) + container_to.size / 2
	
	var line = Line2D.new()
	line.width = 2
	line.default_color = Color(1, 0, 0)  # 设置线的颜色
	line.points = [pos_from, pos_to]
	scroll_container.add_child(line)  # 添加线到场景中
	lines.append(line)
	lines_base_points.append(line.points)


func _on_timer_timeout() -> void:
	var map = CombatProgressGenerator.create_game_map(10, 1, 5)
	CombatProgressGenerator.print_map(map)
	set_container(map)
	draw_map(map)
