class_name  trait_fire
extends Node

var new_fire_number : int
var old_fire_number : int


func _ready():
	owner.player.fire.connect("fire_trait", _on_player_fire_trait)
		

func _on_player_fire_trait(fire_number: int ) -> void:
	new_fire_number = fire_number
	if old_fire_number ==2 and new_fire_number == 3:
		owner.modify_attribute("power_magic","percent",0.5)
	elif old_fire_number ==5 and new_fire_number == 4:
		owner.modify_attribute("power_magic","percent",-1)
	elif old_fire_number ==4 and new_fire_number == 5:
		owner.modify_attribute("power_magic","percent",1)
	elif old_fire_number ==7 and new_fire_number == 6:
		owner.modify_attribute("power_magic","percent",-1.5)
	elif old_fire_number ==6 and new_fire_number == 7:
		owner.modify_attribute("power_magic","percent",1.5)
	elif old_fire_number ==9 and new_fire_number == 8:
		owner.modify_attribute("power_magic","percent",-2)
	elif old_fire_number ==8 and new_fire_number == 9:
		owner.modify_attribute("power_magic","percent",2)
	old_fire_number = new_fire_number

