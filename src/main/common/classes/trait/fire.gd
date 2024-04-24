class_name Fire
extends Node

signal fire_trait(fire_number:int)

func _ready() -> void:
	owner.connect("origins_number_changed",_on_fire_number_change)

func _on_fire_number_change(type, value):
	if type == "fire":
		if fire_number != value:
			fire_number = value

var fire_number = 0 :
	set(v):
		fire_number = v
		fire_trait.emit(v)



