class_name Interactable
extends Area2D

var sprite_2d: Sprite2D

signal interacted(player: PlayerBase)


func _init() -> void:
	collision_layer = 0
	collision_mask = 0
	set_collision_mask_value(2, true)

	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)
	
func interact(player: PlayerBase) -> void:
	# print("[Interact] %s" % owner.name)
	interacted.emit(player)

func _on_body_entered(player: PlayerBase) -> void:
	player.register_interactable(self)
	
func _on_body_exited(player: PlayerBase) -> void:
	player.unregister_interactable(self)
	
func highlight() -> void:
	if is_instance_valid(sprite_2d):
		var tween = create_tween().set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_CUBIC)
		tween.parallel().tween_property(sprite_2d.material, "shader_parameter/line_color", Color.WHITE, 0.3).from(Color.TRANSPARENT)

func unhighlight() -> void:
	if is_instance_valid(sprite_2d):
		var tween = create_tween().set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_CUBIC)
		tween.parallel().tween_property(sprite_2d.material, "shader_parameter/line_color", Color.TRANSPARENT, 0.3).from(Color.WHITE)
