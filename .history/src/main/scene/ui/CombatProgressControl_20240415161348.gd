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


func _ready():
	var map = CombatProgressGenerator.create_game_map(10, 1, 4)
	CombatProgressGenerator.print_map(map)
	draw_map(map)

func draw_map(map):
	var max_layers = len(map)
	var max_nodes_in_layer = 0

	for layer in map:
		var layer_size = layer.size()
		if layer_size > max_nodes_in_layer:
			max_nodes_in_layer = layer_size

	for x in max_layers:
		var vbox_container = VBoxContainer.new()
		vbox_container.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		vbox_container.custom_minimum_size.x = 60
		h_box_container.add_child(vbox_container)
		for y in max_nodes_in_layer:
			var color_rect = ColorRect.new()
			color_rect.color = Color(1, 1, 1, 1)  # 设置节点颜色
			color_rect.size_flags_vertical = Control.SIZE_EXPAND_FILL
			vbox_container.add_child(color_rect)
