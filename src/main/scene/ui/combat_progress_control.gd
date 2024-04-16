extends Control


@onready var h_box_container: HBoxContainer = $VBoxContainer/HBoxContainer/VBoxContainer/ScrollContainer/HBoxContainer
@onready var scroll_container: ScrollContainer = $VBoxContainer/HBoxContainer/VBoxContainer/ScrollContainer
@onready var v_box_container: VBoxContainer = $VBoxContainer/HBoxContainer/VBoxContainer

var node_button = preload("res://src/main/common/classes/ui/combat_progress_node_button.tscn")

var container_matrix := []  # 用于存储CenterContainer的二维数组
var container_size :Vector2 = Vector2.ZERO
var lines := []
var lines_base_points := []

var map_width: float =  125
var map_height: float = 64

func _ready() -> void:
	CombatProgressGenerator.connect("update_combat_progress", _on_update_combat_progress)

func _process(delta: float) -> void:
	v_box_container.size_flags_stretch_ratio = 1/((get_viewport_rect().size.x / map_width - 1)/2)
	
	var index := 0
	for line in lines:
		line.points[0] = lines_base_points[index][0] - Vector2(scroll_container.scroll_horizontal, 0)
		line.points[1] = lines_base_points[index][1] - Vector2(scroll_container.scroll_horizontal, 0)
		index += 1

func set_container(nodes: Array):
	var parameters: Vector2i = CombatProgressGenerator.get_parameters(nodes)
	var max_layers = parameters[0]
	var max_nodes_in_layer = parameters[1]
	
	container_size.x = 30
	container_size.y = map_height / max_nodes_in_layer

	for x in max_layers:
		var vbox_container = VBoxContainer.new()
		vbox_container.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		vbox_container.custom_minimum_size.x = container_size.x
		vbox_container.add_theme_constant_override("separation", 0)
		h_box_container.add_child(vbox_container)
		
		var layer = []
		for node in nodes[x]:
			var center_container = CenterContainer.new()
			center_container.size_flags_horizontal = Control.SIZE_EXPAND_FILL
			center_container.size_flags_vertical = Control.SIZE_EXPAND_FILL
			vbox_container.add_child(center_container)
			layer.append(center_container)

		container_matrix.append(layer)

func get_container_position(index_layer: int, index_node: int) -> Vector2:
	# 预先计算每层的节点垂直间隔
	var nodes_per_layer = container_matrix[index_layer].size()
	var node_spacing_y = map_height / nodes_per_layer
	# 计算x和y的位置
	var pos_x = index_layer * container_size.x + container_size.x / 2
	var pos_y = index_node * node_spacing_y + node_spacing_y / 2
	# 创建并返回节点的位置向量
	return Vector2(pos_x, pos_y)

func draw_nodes(nodes: Array) -> void:
	var parameters: Vector2i = CombatProgressGenerator.get_parameters(nodes)
	var max_layers = parameters[0]
	var max_nodes_in_layer = parameters[1]

	for index_layer in max_layers:
		for node in nodes[index_layer]:
			var index = nodes[index_layer].find(node)
			# 给予node对象container_position，方便后续调用
			node.container_position = get_container_position(index_layer, index)
			var container = container_matrix[index_layer][index]
			var node_button_instance = node_button.instantiate()
			node_button_instance.size_flags_horizontal = Control.SIZE_EXPAND_FILL
			node_button_instance.size_flags_vertical = Control.SIZE_EXPAND_FILL
			node_button_instance.combat_node = node
			container.add_child(node_button_instance)
			
			for connection in node.connections:
				var next_index = nodes[index_layer+1].find(connection)
				draw_connection(Vector2i(index_layer, index), Vector2i(index_layer+1, next_index))

func draw_connection(index_from: Vector2i, index_to: Vector2i) -> void:
	var pos_from = get_container_position(index_from.x, index_from.y)
	var pos_to = get_container_position(index_to.x, index_to.y)
	var line = Line2D.new()
	line.width = 2
	line.default_color = Color(0.812, 0.6, 0.3)  # 设置线的颜色
	line.points = [pos_from, pos_to]
	scroll_container.add_child(line)  # 添加线到场景中
	lines.append(line)
	lines_base_points.append(line.points)

func _on_update_combat_progress(nodes: Array) -> void:
	set_container(nodes)
	draw_nodes(nodes)
	


func _on_texture_button_pressed() -> void:
	Game.next_level = true
