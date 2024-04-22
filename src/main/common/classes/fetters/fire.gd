class_name Fire
extends Node

signal fire_fetters(fire_number:int)

var fire_number = 0:
	set(v):
		fire_number = v
		fire_fetters.emit(v)
		
		
