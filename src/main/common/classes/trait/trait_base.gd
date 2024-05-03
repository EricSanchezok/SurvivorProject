class_name TraitBase
extends Node

var thresholds: Array 
var self_type: AttributesManager.Origins
var count: int = 0:
	set(v):
		var interval_index_now = find_interval_index(count)
		var interval_index_new = find_interval_index(v)
		if interval_index_now != interval_index_new:
			do_interval_change(interval_index_now, interval_index_new)
		count = v

func _ready() -> void:
	owner.connect("origins_number_changed",_on_number_change)

func find_interval_index(value: int):
	var index = 0
	for i in range(thresholds.size()):
		if value >= thresholds[i]:
			index = i + 1
	return index

func do_interval_change(index_now: int, index_new: int) -> void:
	pass


func _on_number_change(type, value):
	count = value if type == self_type else count
