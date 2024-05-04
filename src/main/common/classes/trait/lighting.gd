class_name LightingTrait
extends TraitBase

func _ready() -> void:
	super()
	thresholds = [3, 5, 7, 9]
	self_type = AttributesManager.Origins.LIGHTING

func do_interval_change(index_now: int, index_new: int) -> void:
	var start_index = min(index_now, index_new)
	var end_index = max(index_now, index_new)

	for i in range(start_index, end_index):
		match i:
			0:
				if index_new > index_now: # from 0 to 1
					owner.abm.set_origins_attribute(owner.abm.Origins.LIGHTING, owner.abm.Attributes.NUMBER_OF_LIGHTING_CHAIN, 1)
					owner.abm.set_origins_attribute(owner.abm.Origins.LIGHTING, owner.abm.Attributes.POWER_LIGHTING_CHAIN, 0.2)
				else: # from 1 to 0
					owner.abm.set_origins_attribute(owner.abm.Origins.LIGHTING, owner.abm.Attributes.NUMBER_OF_LIGHTING_CHAIN, -1)
					owner.abm.set_origins_attribute(owner.abm.Origins.LIGHTING, owner.abm.Attributes.POWER_LIGHTING_CHAIN, -0.2)
			1:
				if index_new > index_now: # from 1 to 2
					owner.abm.set_origins_attribute(owner.abm.Origins.LIGHTING, owner.abm.Attributes.NUMBER_OF_LIGHTING_CHAIN, 1)
					owner.abm.set_origins_attribute(owner.abm.Origins.LIGHTING, owner.abm.Attributes.POWER_LIGHTING_CHAIN, 0.2)
				else: # from 2 to 1
					owner.abm.set_origins_attribute(owner.abm.Origins.LIGHTING, owner.abm.Attributes.NUMBER_OF_LIGHTING_CHAIN, -1)
					owner.abm.set_origins_attribute(owner.abm.Origins.LIGHTING, owner.abm.Attributes.POWER_LIGHTING_CHAIN, -0.2)
			2:
				if index_new > index_now: # from 2 to 3
					owner.abm.set_origins_attribute(owner.abm.Origins.LIGHTING, owner.abm.Attributes.NUMBER_OF_LIGHTING_CHAIN, 1)
					owner.abm.set_origins_attribute(owner.abm.Origins.LIGHTING, owner.abm.Attributes.POWER_LIGHTING_CHAIN, 0.3)
				else: # from 3 to 2
					owner.abm.set_origins_attribute(owner.abm.Origins.LIGHTING, owner.abm.Attributes.NUMBER_OF_LIGHTING_CHAIN, -1)
					owner.abm.set_origins_attribute(owner.abm.Origins.LIGHTING, owner.abm.Attributes.POWER_LIGHTING_CHAIN, -0.3)
			3:
				if index_new > index_now: # from 3 to 4
					owner.abm.set_origins_attribute(owner.abm.Origins.LIGHTING, owner.abm.Attributes.NUMBER_OF_LIGHTING_CHAIN, 2)
					owner.abm.set_origins_attribute(owner.abm.Origins.LIGHTING, owner.abm.Attributes.POWER_LIGHTING_CHAIN, 0.3)
				else: # from 4 to 3
					owner.abm.set_origins_attribute(owner.abm.Origins.LIGHTING, owner.abm.Attributes.NUMBER_OF_LIGHTING_CHAIN, -2)
					owner.abm.set_origins_attribute(owner.abm.Origins.LIGHTING, owner.abm.Attributes.POWER_LIGHTING_CHAIN, -0.3)
