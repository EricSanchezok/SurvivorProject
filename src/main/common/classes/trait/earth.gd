extends TraitBase

func _ready() -> void:
	thresholds = [3, 5, 7, 9]
	self_type = Attribute_Changed.Origins.EARTH

		
func do_interval_change(index_now: int, index_new: int) -> void:
	var start_index = min(index_now, index_new)
	var end_index = max(index_now, index_new)

	for i in range(start_index, end_index):
		match i:
			0:
				if index_new > index_now: # from 0 to 1
					owner.player_stats.base_health_shield += 50
					owner.player_stats.damage_reduction_rate += 0.1
				else: # from 1 to 0
					owner.player_stats.base_health_shield -= 50
					owner.player_stats.damage_reduction_rate -= 0.1
			1:
				if index_new > index_now: # from 1 to 2
					owner.player_stats.base_health_shield += 150
					owner.player_stats.damage_reduction_rate += 0.15
				else: # from 2 to 1
					owner.player_stats.base_health_shield -= 150
					owner.player_stats.damage_reduction_rate -= 0.15
			2:
				if index_new > index_now: # from 2 to 3
					owner.player_stats.base_health_shield += 500
					owner.player_stats.damage_reduction_rate += 0.2
				else: # from 3 to 2
					owner.player_stats.base_health_shield -= 500
					owner.player_stats.damage_reduction_rate -= 0.2
			3:
				if index_new > index_now: # from 3 to 4
					owner.player_stats.base_health_shield += 2000
					owner.player_stats.damage_reduction_rate += 0.3
				else: # from 4 to 3
					owner.player_stats.base_health_shield -= 2000
					owner.player_stats.damage_reduction_rate -= 0.3

