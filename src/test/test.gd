extends Node2D



var array: Array[int]


func _ready() -> void:
	array.resize(15)
	array.fill(0)
	print(array)
