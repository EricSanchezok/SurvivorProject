extends Node2D

var enemy: EnemyBase

func _ready() -> void:
	# 椭圆的长轴和短轴长度
	var a = 420.0
	var b = 150.0

	# 你要计算的x坐标
	var x_coords = [a/3, 2*a/3, a]
	# 输出结果
	for x in x_coords:
		print("For x =", x, ", y =", calculate_y_on_ellipse(x, a, b))

# 计算椭圆上的y坐标
func calculate_y_on_ellipse(x, a, b):
	var y_squared = b * b * (1 - (x * x) / (a * a))
	if y_squared < 0:
		return "No real solution"  # 在数学上不可能，除非有计算误差或数据错误
	return sqrt(y_squared)
