class_name WeaponCardSlot
extends PanelContainer

var cards: Array
var type: String = "slot"

func center_position() -> Vector2:
	return global_position + size / 2.0
