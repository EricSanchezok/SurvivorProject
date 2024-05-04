class_name NatureTrait
extends TraitBase

var nature_kills_thresholds: Array = [1,2,3,4,5]
var nature_kills_interval_index_now: float
var nature_kills_interval_index_new: float
var naturetrait_index_new: float
var growth_natural: float

var nature_kills = 0:
	set(v):
		if nature_kills_interval_index_new != nature_kills_thresholds.size():
			nature_kills_interval_index_now = find_nature_kills_interval_index(nature_kills)
			nature_kills_interval_index_new = find_nature_kills_interval_index(v)
			if nature_kills_interval_index_now != nature_kills_interval_index_new:
				do_nature_kills_interval_change(nature_kills_interval_index_now, nature_kills_interval_index_new)
			count = v

func _ready() -> void:
	super()
	thresholds = [2, 4, 6, 8]
	self_type = AttributesManager.Origins.NATURE

func find_nature_kills_interval_index(value: int):
	var index = 0
	for i in range(nature_kills_thresholds.size()):
		if value >= nature_kills_thresholds[i]:
			index = i + 1
	return index

func do_nature_kills_interval_change(index_now: int, index_new: int) -> void:
	match index_new:
		1:
			match naturetrait_index_new:
				1:
					growth_natural = 0.05
				2:
					growth_natural = 0.08
				3:
					growth_natural = 0.12
				4:
					growth_natural = 0.2
		2:
			match naturetrait_index_new:
				1:
					growth_natural = 0.10
				2:
					growth_natural = 0.15
				3:
					growth_natural = 0.22
				4:
					growth_natural = 0.3
		3:
			match naturetrait_index_new:
				1:
					growth_natural = 0.15
				2:
					growth_natural = 0.23
				3:
					growth_natural = 0.35
				4:
					growth_natural = 0.5
		4:
			match naturetrait_index_new:
				1:
					growth_natural = 0.2
				2:
					growth_natural = 0.35
				3:
					growth_natural = 0.55
				4:
					growth_natural = 0.8
		5:
			match naturetrait_index_new:
				1:
					growth_natural = 0.25
				2:
					growth_natural = 0.5
				3:
					growth_natural = 0.8
				4:
					growth_natural = 1.2
	owner.abm.set_origins_attribute(owner.abm.Origins.NATURE, owner.abm.Attributes.GROWTH_NATURAL, growth_natural)


func do_interval_change(index_now: int, index_new: int) -> void:
	var start_index = min(index_now, index_new)
	var end_index = max(index_now, index_new)
	naturetrait_index_new = index_new

	for i in range(start_index, end_index):
		match i:
			0:
				if index_new > index_now: # from 0 to 1
					owner.abm.set_origins_attribute(owner.abm.Origins.NATURE, owner.abm.Attributes.IS_GROW_NATURALLY, 1)
					match nature_kills_interval_index_new:
						1:
							growth_natural = 0.05
						2:
							growth_natural = 0.10
						3:
							growth_natural = 0.15
						4:
							growth_natural = 0.20
						5:
							growth_natural = 0.25
				else: # from 1 to 0
					owner.abm.set_origins_attribute(owner.abm.Origins.NATURE, owner.abm.Attributes.IS_GROW_NATURALLY, -1)
					match nature_kills_interval_index_new:
						1:
							growth_natural = 0
						2:
							growth_natural = 0
						3:
							growth_natural = 0
						4:
							growth_natural = 0
						5:
							growth_natural = 0
			1:
				if index_new > index_now: # from 1 to 2
					match nature_kills_interval_index_new:
						1:
							growth_natural = 0.08
						2:
							growth_natural = 0.16
						3:
							growth_natural = 0.23
						4:
							growth_natural = 0.35
						5:
							growth_natural = 0.5
				else: # from 2 to 1
					match nature_kills_interval_index_new:
						1:
							growth_natural = 0.05
						2:
							growth_natural = 0.10
						3:
							growth_natural = 0.15
						4:
							growth_natural = 0.20
						5:
							growth_natural = 0.25
			2:
				if index_new > index_now: # from 2 to 3
					match nature_kills_interval_index_new:
						1:
							growth_natural = 0.12
						2:
							growth_natural = 0.22
						3:
							growth_natural = 0.35
						4:
							growth_natural = 0.55
						5:
							growth_natural = 0.8
				else: # from 3 to 2
					match nature_kills_interval_index_new:
						1:
							growth_natural = 0.08
						2:
							growth_natural = 0.16
						3:
							growth_natural = 0.23
						4:
							growth_natural = 0.35
						5:
							growth_natural = 0.5
			3:
				if index_new > index_now: # from 3 to 4
					match nature_kills_interval_index_new:
						1:
							growth_natural = 0.2
						2:
							growth_natural = 0.3
						3:
							growth_natural = 0.5
						4:
							growth_natural = 0.8
						5:
							growth_natural = 1.2
				else: # from 4 to 3
					match nature_kills_interval_index_new:
						1:
							growth_natural = 0.12
						2:
							growth_natural = 0.22
						3:
							growth_natural = 0.35
						4:
							growth_natural = 0.55
						5:
							growth_natural = 0.8
	owner.abm.set_origins_attribute(owner.abm.Origins.NATURE, owner.abm.Attributes.GROWTH_NATURAL, growth_natural)
