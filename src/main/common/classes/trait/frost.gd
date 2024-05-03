extends TraitBase

func _ready() -> void:
	thresholds = [2, 4, 6, 8]
	self_type = Attribute_Changed.Origins.FROST

		
func do_interval_change(index_now: int, index_new: int) -> void:
	var start_index = min(index_now, index_new)
	var end_index = max(index_now, index_new)

	for i in range(start_index, end_index):
		match i:
			0:
				if index_new > index_now: # from 0 to 1
					owner.abc.set_origins_attribute(owner.abc.Origins.FROST, owner.abc.Attributes.DECELERATION_RATE, 0.1)
					owner.abc.set_origins_attribute(owner.abc.Origins.FROST, owner.abc.Attributes.FREEZING_RATE, 0.1)
				else: # from 1 to 0
					owner.abc.set_origins_attribute(owner.abc.Origins.FROST, owner.abc.Attributes.DECELERATION_RATE, -0.1)
					owner.abc.set_origins_attribute(owner.abc.Origins.FROST, owner.abc.Attributes.FREEZING_RATE, -0.1)
			1:
				if index_new > index_now: # from 1 to 2
					owner.abc.set_origins_attribute(owner.abc.Origins.FROST, owner.abc.Attributes.DECELERATION_RATE, 0.1)
					owner.abc.set_origins_attribute(owner.abc.Origins.FROST, owner.abc.Attributes.FREEZING_RATE, 0.2)
				else: # from 2 to 1
					owner.abc.set_origins_attribute(owner.abc.Origins.FROST, owner.abc.Attributes.DECELERATION_RATE, -0.1)
					owner.abc.set_origins_attribute(owner.abc.Origins.FROST, owner.abc.Attributes.FREEZING_RATE, -0.2)
			2:
				if index_new > index_now: # from 2 to 3
					owner.abc.set_origins_attribute(owner.abc.Origins.FROST, owner.abc.Attributes.DECELERATION_RATE, 0.1)
					owner.abc.set_origins_attribute(owner.abc.Origins.FROST, owner.abc.Attributes.FREEZING_RATE, 0.3)
				else: # from 3 to 2
					owner.abc.set_origins_attribute(owner.abc.Origins.FROST, owner.abc.Attributes.DECELERATION_RATE, -0.1)
					owner.abc.set_origins_attribute(owner.abc.Origins.FROST, owner.abc.Attributes.FREEZING_RATE, -0.3)
			3:
				if index_new > index_now: # from 3 to 4
					owner.abc.set_origins_attribute(owner.abc.Origins.FROST, owner.abc.Attributes.DECELERATION_RATE, 0.2)
					owner.abc.set_origins_attribute(owner.abc.Origins.FROST, owner.abc.Attributes.FREEZING_RATE, 0.4)
				else: # from 4 to 3
					owner.abc.set_origins_attribute(owner.abc.Origins.FROST, owner.abc.Attributes.DECELERATION_RATE, -0.2)
					owner.abc.set_origins_attribute(owner.abc.Origins.FROSTs, owner.abc.Attributes.FREEZING_RATE, -0.4)
