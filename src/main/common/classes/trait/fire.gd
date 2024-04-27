class_name Fire
extends Node

@export var threshold: Array = [3, 5, 7, 9]

func _ready() -> void:
	owner.connect("origins_number_changed",_on_number_change)

var count: int = 0:
	set(v):
		if count < 3 and v == 3:
			owner.abc.set_origins_attribute(owner.abc.Origins.FIRE, owner.abc.Attributes.POWER_MAGIC,0.5)
		elif count ==5 and v < 5:
			owner.abc.set_origins_attribute(owner.abc.Origins.FIRE, owner.abc.Attributes.POWER_MAGIC,-1)
		elif count < 5 and v == 5:
			owner.abc.set_origins_attribute(owner.abc.Origins.FIRE, owner.abc.Attributes.POWER_MAGIC,1)
		elif count ==7 and v < 7:
			owner.abc.set_origins_attribute(owner.abc.Origins.FIRE, owner.abc.Attributes.POWER_MAGIC,-1.5)
		elif count < 7 and v == 7:
			owner.abc.set_origins_attribute(owner.abc.Origins.FIRE, owner.abc.Attributes.POWER_MAGIC,1.5)
		elif count ==9 and v < 9:
			owner.abc.set_origins_attribute(owner.abc.Origins.FIRE, owner.abc.Attributes.POWER_MAGIC,-3)
		elif count < 9 and v == 9:
			owner.abc.set_origins_attribute(owner.abc.Origins.FIRE, owner.abc.Attributes.POWER_MAGIC,3)
		count = v

func _on_number_change(type, value):
	count = value if type == Attribute_Changed.Origins.FIRE else count	
