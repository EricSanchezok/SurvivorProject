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
	for layer in map:
		for node in layer:
			var node_ui = ColorRect.new()
			node_ui.size = Vector2(50, 50)  # 设置节点大小
			node_ui.color = type_colors[node.type]
