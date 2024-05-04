class_name Npc
extends CharacterBody2D


func _ready() -> void:
	var template_material = $Sprite2D.material.duplicate()
	$Sprite2D.material = template_material
