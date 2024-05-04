class_name ToxinTrait
extends TraitBase

func _ready() -> void:
	super()
	thresholds = [2, 4, 6, 8]
	self_type = AttributesManager.Origins.TOXIN

		
func do_interval_change(index_now: int, index_new: int) -> void:
	var start_index = min(index_now, index_new)
	var end_index = max(index_now, index_new)

	for i in range(start_index, end_index):
		match i:
			0:
				if index_new > index_now: # from 0 to 1
					owner.abm.set_origins_attribute(owner.abm.Origins.TOXIN, owner.abm.Attributes.POISON_LAYERS, 1)
					owner.abm.set_origins_attribute(owner.abm.Origins.TOXIN, owner.abm.Attributes.MAX_POISON_LAYERS, 10)
				else: # from 1 to 0
					owner.abm.set_origins_attribute(owner.abm.Origins.TOXIN, owner.abm.Attributes.POISON_LAYERS, -1)
					owner.abm.set_origins_attribute(owner.abm.Origins.TOXIN, owner.abm.Attributes.MAX_POISON_LAYERS, -10)
			1:
				if index_new > index_now: # from 1 to 2
					owner.abm.set_origins_attribute(owner.abm.Origins.TOXIN, owner.abm.Attributes.POISON_LAYERS, 0)
					owner.abm.set_origins_attribute(owner.abm.Origins.TOXIN, owner.abm.Attributes.MAX_POISON_LAYERS, 10)
				else: # from 2 to 1
					owner.abm.set_origins_attribute(owner.abm.Origins.TOXIN, owner.abm.Attributes.POISON_LAYERS, -0)
					owner.abm.set_origins_attribute(owner.abm.Origins.TOXIN, owner.abm.Attributes.MAX_POISON_LAYERS, -10)
			2:
				if index_new > index_now: # from 2 to 3
					owner.abm.set_origins_attribute(owner.abm.Origins.TOXIN, owner.abm.Attributes.POISON_LAYERS, 0)
					owner.abm.set_origins_attribute(owner.abm.Origins.TOXIN, owner.abm.Attributes.MAX_POISON_LAYERS, 10)
				else: # from 3 to 2
					owner.abm.set_origins_attribute(owner.abm.Origins.TOXIN, owner.abm.Attributes.POISON_LAYERS, -0)
					owner.abm.set_origins_attribute(owner.abm.Origins.TOXIN, owner.abm.Attributes.MAX_POISON_LAYERS, -10)
			3:
				if index_new > index_now: # from 3 to 4
					owner.abm.set_origins_attribute(owner.abm.Origins.TOXIN, owner.abm.Attributes.POISON_LAYERS, 1)
					owner.abm.set_origins_attribute(owner.abm.Origins.TOXIN, owner.abm.Attributes.MAX_POISON_LAYERS, 999)
				else: # from 4 to 3
					owner.abm.set_origins_attribute(owner.abm.Origins.TOXIN, owner.abm.Attributes.POISON_LAYERS, -1)
					owner.abm.set_origins_attribute(owner.abm.Origins.TOXIN, owner.abm.Attributes.MAX_POISON_LAYERS, -999)


