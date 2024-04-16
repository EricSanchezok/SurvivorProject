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

var container_matrix := []  # 用于存储CenterContainer的二维数组

func _ready():
	var map = CombatProgressGenerator.create_game_map(10, 1, 4)
	CombatProgressGenerator.print_map(map)
	draw_map(map)

func draw_map(map):
	var parameters: Vector2i = CombatProgressGenerator.get_parameters(map)
	var max_layers = parameters[0]
	var max_nodes_in_layer = parameters[1]

	for x in max_layers:
		var vbox_container = VBoxContainer.new()
		vbox_container.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		vbox_container.custom_minimum_size.x = 60
		h_box_container.add_child(vbox_container)
		
		var layer = []
		
		for y in max_nodes_in_layer:
			var center_container = CenterContainer.new()
			center_container.size_flags_vertical = Control.SIZE_EXPAND_FILL
			vbox_container.add_child(center_container)
			layer.append(center_container)

		container_matrix.append(layer)
		
	draw_connection(Vector2(0, 0), Vector2(0, 1))

func draw_connection(index_from: Vector2, index_to: Vector2):
	var container_from = container_matrix[index_from.x][index_from.y]
	var container_to = container_matrix[index_to.x][index_to.y]
	var pos_from = Vector2(index_from.x * container_from.size.x, index_from.y * container_from.size.y)
	var pos_to = index_to * container_to.size
	var line = Line2D.new()
	line.width = 10
	line.default_color = Color(1, 1, 1)  # 设置线的颜色
	print(pos_from)
	print(pos_to)
	# 计算两个容器中心的坐标
	var start_pos = container_from.global_position + container_from.size / 2
	var end_pos = container_to.global_position + container_to.size / 2
	line.points = [start_pos, end_pos]
	add_child(line)  # 添加线到场景中
