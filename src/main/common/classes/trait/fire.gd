class_name Fire
extends Node

signal fire_trait(fire_number:int)

var fire_number = 0:
	set(v):
		fire_number = v
		fire_trait.emit(v)
		

