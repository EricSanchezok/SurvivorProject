extends Control


@onready var marker_2d: Marker2D = $Marker2D


# >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> 商店相关变量初始化 >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
@export var from: Control
@export var card_scene: PackedScene
var card_offset_x: float = 53.0
var rot_max: float = deg_to_rad(10.0)
var anim_offset_y: float = 3.0
var time_multiplier: float = 3.0
var tween: Tween
var tween_animate: Tween
var time: float = 0.0
var sine_offset_mult: float = 0.0
var drawn: bool = false

var cards: Array
var cards_pos: Array


func _ready():
	set_process(false)
	
	# Convert degrees to radians to use lerp_angle later
	rot_max = deg_to_rad(rot_max)
	await get_tree().create_timer(2.0).timeout
	#draw_cards(from.global_position, 10)

func _physics_process(delta: float) -> void:
	pass
	#time += delta
	#for card in cards:
		#var i := cards.find(card)
		#var val: float = sin(i + (time * time_multiplier))
		#print("Child %d, sin(%d) = %f" % [i, i, val])
		#card.position.y = cards_pos[i].y + val * sine_offset_mult

func draw_cards(from_pos: Vector2, number: int) -> void:
	drawn = true
	clear_cards()
	if tween and tween.is_running():
		tween.kill()
	tween = create_tween().set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_CUBIC)
			
	for i in range(number):
		var instance: Button = card_scene.instantiate()
		add_child(instance)
		instance.global_position = from_pos
		
		var final_pos: Vector2 = -(instance.size / 2.0) - Vector2(card_offset_x * (number - 1 - i), 0.0) + marker_2d.position
		var rot_radians: float = lerp_angle(-rot_max, rot_max, float(i)/float(number-1))
		# Animate pos
		tween.parallel().tween_property(instance, "position", final_pos, 0.3 + (i * 0.075))
		tween.parallel().tween_property(instance, "rotation", rot_radians, 0.3 + (i * 0.075))
		
		cards.append(instance)
		cards_pos.append(final_pos)
	
	tween.tween_callback(set_process.bind(true))
	tween.tween_property(self, "sine_offset_mult", anim_offset_y, 1.5).from(0.0)

func undraw_cards(to_pos: Vector2) -> void:
	drawn = false
	if tween and tween.is_running():
		tween.kill()
	tween = create_tween().set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_CUBIC)
	
	tween.tween_property(self, "sine_offset_mult", 0.0, 0.9)
	
	for card in cards:
		tween.parallel().tween_property(card, "global_position", to_pos, 0.3 + ((cards.size() - cards.find(card)) * 0.075))
		tween.parallel().tween_property(card, "rotation", 0.0, 0.3 + ((cards.size() - cards.find(card)) * 0.075))
	
	await tween.finished
	
	clear_cards()

func animate_cards() -> void:
	if tween_animate and tween_animate.is_running():
		tween_animate.kill()
	tween_animate = create_tween().set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_CUBIC)
	tween_animate.set_loops()
	for i in range(get_child_count()):
		var c: Button = get_child(i)
		
func clear_cards() -> void:
	for card in cards:
		card.queue_free()
		
	cards.clear()
	cards_pos.clear()
		


func _on_refresh_button_pressed() -> void:
	if drawn:
		undraw_cards(from.global_position)
	else:
		draw_cards(from.global_position, 5)
