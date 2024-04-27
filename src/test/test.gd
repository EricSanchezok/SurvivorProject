extends Node2D

@export var thresholds: Array = [3, 5, 7, 9]

var array: Array[int]


func _ready() -> void:
	do_interval_change(3, 0)


func do_interval_change(index_now: int, index_new: int) -> void:
	var start_index = min(index_now, index_new)
	var end_index = max(index_now, index_new)

	for i in range(start_index, end_index):
		match i:
			0:
				if index_new > index_now:
					print("from 0 to 1")
				else:
					print("from 1 to 0")
			1:
				if index_new > index_now:
					print("from 1 to 2")
				else:
					print("from 2 to 1")
			2:
				if index_new > index_now:
					print("from 2 to 3")
				else:
					print("from 3 to 2")
			3:
				if index_new > index_now:
					print("from 3 to 4")
				else:
					print("from 4 to 3")
	
