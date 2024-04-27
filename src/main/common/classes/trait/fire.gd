class_name Fire
extends Node
var abc 

func _ready() -> void:
	owner.connect("origins_number_changed",_on_fire_number_change)


func _on_fire_number_change(type, value):
	if type == Attribute_Changed.Origins.FIRE:
		if fire_number != value:
			fire_number = value

var fire_number = 0 :
	set(v):
		abc = owner.abc
		if fire_number < 3 and v == 3:
			abc.set_origins_attribute(abc.Origins.FIRE, abc.Attributes.POWER_MAGIC,0.5)
		elif fire_number ==5 and v < 5:
			abc.set_origins_attribute(abc.Origins.FIRE, abc.Attributes.POWER_MAGIC,-1)
		elif fire_number < 5 and v == 5:
			abc.set_origins_attribute(abc.Origins.FIRE, abc.Attributes.POWER_MAGIC,1)
		elif fire_number ==7 and v < 7:
			abc.set_origins_attribute(abc.Origins.FIRE, abc.Attributes.POWER_MAGIC,-1.5)
		elif fire_number < 7 and v == 7:
			abc.set_origins_attribute(abc.Origins.FIRE, abc.Attributes.POWER_MAGIC,1.5)
		elif fire_number ==9 and v < 9:
			abc.set_origins_attribute(abc.Origins.FIRE, abc.Attributes.POWER_MAGIC,-3)
		elif fire_number < 9 and v == 9:
			abc.set_origins_attribute(abc.Origins.FIRE, abc.Attributes.POWER_MAGIC,3)
		fire_number = v

