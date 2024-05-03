extends TraitBase

func _ready() -> void:
	thresholds = [3, 5, 7, 9]
	self_type = AttributesManager.Origins.FIRE

		
func do_interval_change(index_now: int, index_new: int) -> void:
	var start_index = min(index_now, index_new)
	var end_index = max(index_now, index_new)

	for i in range(start_index, end_index):
		match i:
			0:
				if index_new > index_now: # from 0 to 1
					owner.abc.set_origins_attribute(owner.abc.Origins.FIRE, owner.abc.Attributes.POWER_MAGIC, 0.5)
				else: # from 1 to 0
					owner.abc.set_origins_attribute(owner.abc.Origins.FIRE, owner.abc.Attributes.POWER_MAGIC, -0.5)
			1:
				if index_new > index_now: # from 1 to 2
					owner.abc.set_origins_attribute(owner.abc.Origins.FIRE, owner.abc.Attributes.POWER_MAGIC, 1)
				else: # from 2 to 1
					owner.abc.set_origins_attribute(owner.abc.Origins.FIRE, owner.abc.Attributes.POWER_MAGIC, -1)
			2:
				if index_new > index_now: # from 2 to 3
					owner.abc.set_origins_attribute(owner.abc.Origins.FIRE, owner.abc.Attributes.POWER_MAGIC, 1.5)
				else: # from 3 to 2
					owner.abc.set_origins_attribute(owner.abc.Origins.FIRE, owner.abc.Attributes.POWER_MAGIC, -1.5)
			3:
				if index_new > index_now: # from 3 to 4
					owner.abc.set_origins_attribute(owner.abc.Origins.FIRE, owner.abc.Attributes.POWER_MAGIC, 3)
				else: # from 4 to 3
					owner.abc.set_origins_attribute(owner.abc.Origins.FIRE, owner.abc.Attributes.POWER_MAGIC, -3)
